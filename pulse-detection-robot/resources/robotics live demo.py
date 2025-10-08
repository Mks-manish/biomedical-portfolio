import joblib
import numpy as np
from datacleanup import tactile_data_cleaner as tdc
from data_extracter import data_extraction as de
from certain_frame import certain_frame_extractor as cfe
from one_second_avg import one_second_average as osa
from certain_sweat import certain_frame_sweat as cfs
from one_sec_ac_pressure_avg import one_second_sweat as oss
from sweat_frequency_extractor import sweat_freq_extractor as sfe


#####################DEMO############################



###################LOADING MODELS#####################
model_test = joblib.load("contactModel.pkl")
sweat_test = joblib.load("sweatModel.pkl")
#######################################################


file_path = '/Users/sagarsharma/Documents/Tactile Data/Excel Data/live demo.xlsx'

################## DATA FOR CONTACT MODEL ######################
df1 = tdc(file_path)
ac_pressure1, dc_pressure1, ac_temperature1, dc_temperature1, all_time1 = de(df1)   
frame1_data = osa(dc_pressure1)

print("TESTING CONTACT:")
for i in range(len(frame1_data)):
    test_value1 = np.array(([frame1_data[i]]))
    test_value1 = test_value1.reshape(-1,1)
    truth1 = model_test.predict(test_value1)
    
    if model_test.predict(test_value1) == 1:
        print("NO CONTACT, TIME (S):",i)
    else:
        print("CONTACT, TIME (S):",i)

############################################################



############### DATA FOR SWEAT MODEL ######################


frame2_data = cfs(ac_pressure1,5,10)
sweat_time_data = oss(frame2_data)
sweat_freq_data = sfe(frame2_data)
time_sweat = np.array((sweat_time_data))
freq_sweat = np.array((sweat_freq_data))
test_data_sweat= list(zip(time_sweat,freq_sweat))

print("TESTING SWEAT:")

if sweat_test.predict(test_data_sweat) == 1:
    print("SWEAT")
elif sweat_test.predict(test_data_sweat) == 0:
    print("NO SWEAT")


############################################################




