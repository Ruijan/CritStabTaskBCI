#define START 0
#define VALUE 1
#define MODE 2
#define END 3
#define CONNECT 1
#define DISCONNECT 255
#define CORRECTSTART 1
#define CORRECTEND 255

#define VERBOSE 2
#define DISCRETEMOTORS 3
#define VERBOSEDISCRETEMOTORS 4

int state = 0;
bool isConnected = false;
const unsigned int messageSize = 4;
uint8_t message[messageSize];
const uint8_t nbMotors = 4;
const uint8_t motorsPin[nbMotors] = {3, 5, 6, 8};

void setup()
{
  // start serial port at 9600 bps and wait for port to open:
  Serial.begin(9600);
  for(int i = 0; i < nbMotors; i++){
    pinMode(motorsPin[i], OUTPUT);
  }
}

void loop()
{
  unsigned int availableBytes = Serial.available();
  if(availableBytes >= messageSize){
    for(int i = 0 ; i < messageSize; i++){
      message[i] = Serial.read();
    }
    if(message[START] == CORRECTSTART && message[END] == CORRECTEND){
      if(!isConnected){
        if(message[MODE] == CONNECT){
          sendMessageBack();
          isConnected = true;
        }
      }
      else{
        if(message[MODE] == DISCONNECT){
          sendMessageBack();
          isConnected = false;
        }
        else {
          if(message[MODE] >= 2 && message[MODE] < 10){
            if(message[MODE]%VERBOSE == 0){
              sendMessageBack();
            }
            if(message[MODE] == VERBOSEDISCRETEMOTORS || 
            message[MODE] == DISCRETEMOTORS){
              setDiscreteMotorsFromMessage();
            }
          }
        }
      }
    }
  }
}

void sendMessageBack(){
  Serial.write(message[START]);
  Serial.write(message[VALUE]);
  Serial.write(message[MODE]);
  Serial.write(message[END]);
  Serial.flush();
}

void setDiscreteMotorsFromMessage(){
  for(int i = 0; i < nbMotors; i++){
    if(i == message[VALUE]){
      digitalWrite(motorsPin[i], HIGH);
    }
    else{
      digitalWrite(motorsPin[i], LOW);
    }
  }
}
