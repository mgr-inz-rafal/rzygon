import sys

byte2char = {
	  0:' ',
	  1:'!',
	  2:'"',
	  3:'#',
	  4:'$',
	  5:'%',
	  6:'&',
	  7:'\'',
	  8:'(',
 	  9:')',
	 10:'*',
	 11:'+',
	 12:',',
	 13:'-',
	 14:'.',
	 15:'/',
	 16:'0',
	 17:'1',
	 18:'2',
	 19:'3',
	 20:'4',
	 21:'5',
	 22:'6',
	 23:'7',
	 24:'8',
	 25:'9',
	 26:':',
	 27:';',
	 28:'<',
	 29:'=',
	 30:'>',
	 31:'?',
	 32:' ',
	 33:'A',
	 34:'B',
	 35:'C',
	 36:'D',
	 37:'E',
	 38:'F',
	 39:'G',
	 40:'H',
	 41:'I',
	 42:'J',
	 43:'K',
	 44:'L',
	 45:'M',
	 46:'N',
	 47:'O',
	 48:'P',
	 49:'Q',
	 50:'R',
	 51:'S',
	 52:'T',
	 53:'U',
	 54:'V',
	 55:'W',
	 56:'X',
	 57:'Y',
	 58:'Z',
	 59:'[',
	 60:'\\',
	 61:']',
	 97:'a',
	 98:'b',
	 99:'c',
	100:'d',
	101:'e',
	102:'f',
	103:'g',
	104:'h',
	105:'i',
	106:'j',
	107:'k',
	108:'l',
	109:'m',
	110:'n',
	111:'o',
	112:'p',
	113:'q',
	114:'r',
	115:'s',
	116:'t',
	117:'u',
	118:'v',
	119:'w',
	120:'x',
	121:'y',
	122:'z',
	123:'Ł',
	 90:'ż',
	 88:'Ż',
	 86:'Ć',
	 83:'ś',
	 82:'Ę',
	 81:'Ą',
	 80:'Ó',
	 79:'ó',
	 78:'ń',
	 77:'Ń',
	 76:'ł',
	 75:'ź',
	 69:'ę',
	 68:'Ś',
	 67:'ć',
	 65:'ą',
	 64:'Ź'
	}
	
if len(sys.argv) != 2:
	print('Jebnij mapom')
	sys.exit()
	
def char2byte(c):
	for by, ch in byte2char.items():
		if ch == c:
			return (by + 128).to_bytes(1, 'big') # Compensate for Atari inverse
	print("Invalid character: ", c, sep="")
	sys.exit()

def read_atar_line(f):
	ret = b""
	first = byte = f.read(1);
	if byte == b"" or byte == b'\x9b':
		return ""
	while 1:
		byte = f.read(1)
		if byte == b'\x9b' or byte == b"":
			return first + ret
		ret += byte
		
def write_atari_line(str, f):
	f.write(str)
	f.write(b'\x9b')
		
def print_atari_string(str):
	for c in str:
		print(byte2char[c-128], end="")	# Remove Atari inverse
	print()

with open(sys.argv[1], "rb") as f:
	print("Processing file: \"", sys.argv[1], "\"...", sep="")
	line = "dupa"
	lines = []
	index = 0
	while line != "":
		line = read_atar_line(f)
		lines.append(line)
		
lines.pop()
last = lines[len(lines)-1]
print("Current name: ", end="")
print_atari_string(last)
while 1:
	new = input("Enter new name (max. 21 chars): ")
	if len(new) > 21:
		print("Too long (", len(new), ")", sep="")
	else:
		break
newfname = sys.argv[1] + "_EN"
print("Writing map to file: ", newfname, "...", sep="")

with open(newfname, "wb") as f:
	for i in range(0, len(lines)-1):
		write_atari_line(lines[i], f)
	for c in new:
		f.write(char2byte(c))
	f.write(b'\x9b')
print("Done!")