# Helper script that randomizes the disappearance of the hell gate

import random

w = 9
h = 8
count_list = list(range(0, w*h))
random.shuffle(count_list)

while count_list:
	value = count_list.pop()
	row = int(value / w)
	column = value % w
	
	print("\t\t\t\tstx screen_mem+40*(10+",row,")+(24+",column,")", sep="")
	print("\t\t\t\tdelay")
	
	
#	print(value, "\t= ", int(value / w), value % w)
