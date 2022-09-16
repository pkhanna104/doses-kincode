
"""
Future protocol:

1. Select conditions
2. Select start
3. Instantiate game class
4. Run game init()
5. Run game update() at sampling rate (50 Hz)
6. Game reads from sensors and determines game state
7. Cycles through state transformation dictionary on state of each trial
8. Write a) time, b) sensor values, c) trial number, d) trial type, e) trial state at every task loop, start sound, end sound

Considerations
- How to save data the entire time, while managing the task? --> threading? a lot of calls? Two programs, match up times? Need to maintain 50 Hz
- need to write to Arduino?
- timing of conditions depends on task design
- Table (and can easily name columns)
- create new Processes for other sensing data
"""

import serial
import csv
import time
import datetime
#import pygame
import multiprocessing as mp
mp.set_start_method('spawn', force=True)
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


def record_data(data_csv, event):
    my_serial = serial.Serial(port='COM4', baudrate=9600)
    print('Connecting Arduino.')
    # time.sleep(3)    # to avoid ValueError from Arduino
    start_time = time.time()
    while time.time() < start_time + 600: # 10 minutes. 
        data = read_arduino(my_serial)
        if data:
            with open(data_csv, 'a') as f:
                writer = csv.writer(f, delimiter=',')
                t = datetime.datetime.now()
                writer.writerow([np.array([t.hour, t.minute, t.second, t.microsecond]), data])
        if event.is_set():
            my_serial.close()
            break


def read_arduino(my_serial):
    ''' Read sensor value from Arduino. '''
    my_serial.flushInput()
    data = my_serial.readline()
    data = data.decode('utf-8')    # bytes to string
    if any(char.isdigit() for char in data):
        data = int(''.join(filter(str.isdigit, data.strip())))    # extract digits
        return data


class Experiment():

    def __init__(self, trial_len=3, my_port='COM4'):
        self.trial_len = trial_len
        self.trial_num = 0
        self.sound = 0
        self.data_csv, self.states_csv, self.merged_csv, self.cur_time = self.generate_filenames()
        self.cur_state = 'init'
        self.change_state('init')
        self.my_port = my_port
        self.merged_df = pd.DataFrame()
        #self.my_serial = self.connect_arduino()
        #pygame.mixer.init()

        '''
        For now, manually enter tasks.
        Will streamline when have a set protocol for tasks.
        '''
        #num_tasks = 10
        #self.tasks = ['some_task' for _ in range(num_tasks)]
        
        self.new_process()
        self.merge_csv()
        #self.plot_merged()

    def run_trials(self, event):
        '''
        Currently automatically goes to next trial.
        '''
        start_time = time.time()
        more_trials = True

        #while self.trial_num < len(self.tasks) and time.time() < start_time + 600:    # 10 min max
        while more_trials:
            typed = input('Press ENTER to BEGIN trial '+str(self.trial_num+1)+' or q+ENTER to quit and save.\n')
            
            if typed == 'q':
                print ('\nSaving and quitting')
                time.sleep(1.)
                more_trials = False
            
            else:
                print('\nStarting of Trial ', str(self.trial_num+1))
                print('\n . ')
                print('\n .. ')
                print('\n ... ')
                print('\n ')
                # self.sound = pygame.mixer.get_busy()
                self.play_sound()
                self.change_state('task_some_task')

            #time_end = time.time() + self.trial_len
            #while time.time() < time_end:
            #    continue
            if more_trials:
                typed = input('Press ENTER to END trial ' + str(self.trial_num+1) +' or q+ENTER to quit and save.\n')
                if typed == 'q':
                    print('\nSaving and quitting')
                    more_trials = False
                else:
                    print('\nEnd of trial '+str(self.trial_num+1))
                    print('\n ')
                    print('\n ')
                    print('\n ')

                self.play_sound()
                self.change_state('btwn_trial')
                time.sleep(1.)    # time so that ending noise goes off
                self.trial_num += 1

        event.set()
        #self.my_serial.close()
        print('End of File')

    def change_state(self, new_state):
        self.cur_state = new_state
        with open(self.states_csv, 'a') as f:
            writer = csv.writer(f, delimiter=',')
            t = datetime.datetime.now()
            writer.writerow([np.array([t.hour, t.minute, t.second, t.microsecond]), self.cur_state, self.trial_num])

    def play_sound(self):
        pass
        # start trial
        # if self.cur_state == 'init' or self.cur_state == 'btwn_trial':
        #   pygame.mixer.music.load('slowedstart.mp3')
        #   pygame.mixer.music.play()
        # # end trial
        # else:
        #   pygame.mixer.music.load('slowedend.mp3')
        #   pygame.mixer.music.play()

    def new_process(self):
        # if __name__ == '__main__':
        event = mp.Event()
        record = mp.Process(target=record_data, args=(self.data_csv, event))
        record.start()
        time.sleep(3)
        self.run_trials(event)
        record.join()

    def generate_filenames(self):
        cur_time = time.strftime("%Y%m%d-%H%M%S")
        data_name = str('data_' + cur_time + '.csv')
        states_name = str('states_' + cur_time + '.csv')
        merged_name = str('merged_' + cur_time + '.csv')
        return data_name, states_name, merged_name, cur_time

    def merge_csv(self):
        data = pd.read_csv(self.data_csv, names=['timestamp','ard_val'])
        states = pd.read_csv(self.states_csv, names=['timestamp', 'state', 'trial_num'])
        self.merged_df = pd.merge_asof(data, states, on='timestamp')
        self.merged_df.to_csv(self.merged_csv)

    def plot_merged(self):
        self.clean_merged()
        self.merged_df.plot(x='timestamp',y='ard_val', color='red')
        plt.xlabel('time (s)')
        plt.ylabel('force (V)')
        plt.ylim(0, 5)
        self.plot_lines()
        plt.savefig(self.cur_time)

    def clean_merged(self):
        # shift seconds to 0
        self.merged_df[['timestamp','ard_val']] = self.merged_df[['timestamp','ard_val']].apply(pd.to_numeric)
        start_time = self.merged_df['timestamp'].iloc[0]
        self.merged_df['timestamp'] = self.merged_df['timestamp'].apply(lambda r: r - start_time)
        # Arduino units --> Volts
        self.merged_df['ard_val'] = self.merged_df['ard_val'].apply(lambda r: r*0.0048828125)

    def plot_lines(self):
        # get start and end lines from merged data
        lines = []
        prev_state = m['state'].iloc[0]
        for i, row in m.iterrows():
            if row['state'] != prev_state:
                lines.append(row['timestamp'])
            prev_state = row['state']
        for i,k in zip(lines[0::2], lines[1::2]):
            plt.axvline(x=i, color='grey')
            plt.axvline(x=k, color='grey')
            plt.axvspan(i, k, color='#e8e8e8')


if __name__ == '__main__':
    Experiment()

