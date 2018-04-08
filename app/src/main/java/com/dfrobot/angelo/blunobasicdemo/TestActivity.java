package com.dfrobot.angelo.blunobasicdemo;

import android.content.Intent;
import android.os.Environment;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.StringTokenizer;


public class TestActivity extends BlunoLibrary {
    private Button buttonScan;
    private Button buttonSerialSend;
    private Button buttonSerialRead;
    private EditText serialSendText;
    private TextView serialReceivedText;
    private ArrayList<int[]> readings;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);
        onCreateProcess();                                        //onCreate Process by BlunoLibrary


        serialBegin(115200);                                       //set the Uart Baudrate on BLE chip to 115200

        serialReceivedText=(TextView) findViewById(R.id.serialReveicedText);   //initial the EditText of the received data
        serialSendText=(EditText) findViewById(R.id.serialSendText);         //initial the EditText of the sending data

        buttonSerialSend = (Button) findViewById(R.id.buttonSerialSend);      //initial the button for sending the data
        buttonSerialSend.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                if(buttonSerialSend.getText().equals("SEND DATA")) {
                    serialSend(serialSendText.getText().toString());            //send the data to the BLUNO
                    buttonSerialSend.setText("STOP SENDING");
                }
                else if(buttonSerialSend.getText().equals("STOP SENDING")){
                    buttonSerialSend.setText("SEND DATA");
                }
                /*else if(buttonSerialSend.getText().equals("RESUME")) {
                    if(mConnectionState != mConnectionState.isConnected)
                    {
                        buttonScanOnClickProcess();
                    }                          //Alert Dialog for selecting the BLE device
                    serialSend(serialSendText.getText().toString());            //send the data to the BLUNO
                    buttonSerialSend.setText("STOP SENDING");
                }*/
            }
        });
        buttonScan = (Button) findViewById(R.id.buttonScan);               //initial the button for scanning the BLE device
        buttonScan.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub

                buttonScanOnClickProcess();                               //Alert Dialog for selecting the BLE device
            }
        });


        buttonSerialRead = (Button) findViewById(R.id.read);      //initial the button for sending the data
        buttonSerialRead.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                if(buttonSerialRead.getText().equals("READ")) {
                    if(mConnectionState != mConnectionState.isConnected)
                    {
                        buttonScanOnClickProcess();
                    }
                    serialSend(serialSendText.getText().toString());            //send the data to the BLUNO
                    buttonSerialRead.setText("STOP READING");
                }
                else if(buttonSerialRead.getText().equals("STOP READING")) {
                    buttonSerialRead.setText("READ");
                    if (mConnectionState == mConnectionState.isConnected) {
                        buttonScanOnClickProcess();                                        //Alert Dialog for selecting the BLE device
                    }
                }
            }
        });
        readings = new ArrayList<int[]>();
    }


    protected void onResume(){
        super.onResume();
        System.out.println("BlUNOActivity onResume");
        onResumeProcess();                                        //onResume Process by BlunoLibrary
    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        onActivityResultProcess(requestCode, resultCode, data);                //onActivityResult Process by BlunoLibrary
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onPause() {
        super.onPause();
        onPauseProcess();                                         //onPause Process by BlunoLibrary
    }

    protected void onStop() {
        super.onStop();
        onStopProcess();                                          //onStop Process by BlunoLibrary
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        onDestroyProcess();                                           //onDestroy Process by BlunoLibrary
    }

    @Override
    public void onConectionStateChange(BlunoLibrary.connectionStateEnum theConnectionState) {//Once connection state changes, this function will be called
        switch (theConnectionState) {                                //Four connection state
            case isConnected:
                buttonScan.setText("Connected");
                break;
            case isConnecting:
                buttonScan.setText("Connecting");
                break;
            case isToScan:
                buttonScan.setText("Scan");
                break;
            case isScanning:
                buttonScan.setText("Scanning");
                break;
            case isDisconnecting:
                buttonScan.setText("isDisconnecting");
                break;
            default:
                break;
        }
    }

    @Override
    public void onSerialReceived(String theString) {                     //Once connection data received, this function will be called
        // TODO Auto-generated method stub
        serialReceivedText.append(theString + "\n");                    //append the text into the EditText
        try
        {
            //section to save the string to the variable
            String [] splitString = theString.split("\\s");
            int[] temp = new int[4];
            if(splitString.length >= 4) {
                for (int x = 0; x < temp.length; x++) {
                    serialReceivedText.append(splitString[x]+"\n");
                    temp[x] = Integer.parseInt(splitString[x]);
                }
                readings.add(temp);
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
            serialReceivedText.setText(e.toString());
            //serialReceivedText.setText(theString);
        }
        //The Serial data from the BLUNO may be sub-packaged, so using a buffer to hold the String is a good choice.
        ((ScrollView)serialReceivedText.getParent()).fullScroll(View.FOCUS_DOWN);
    }

    // Check if external storage is available to read and write
    public boolean isExternalStorageWritable() {
        String state = Environment.getExternalStorageState();
        return (Environment.MEDIA_MOUNTED.equals(state));
    }
    public void saveData(View view) {
        try {
            String externalfilename = "MessageFileExternal.txt";
            if (isExternalStorageWritable()) {
            } else {
                serialReceivedText.setText("not writable");
            }
            File file = Environment.getExternalStorageDirectory();
            File newFile = new File(file, "Wearable App");
            if (!newFile.exists()) {
                newFile.mkdirs();
            }
         /*int variable = 0;
         if(ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED)
         {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, variable);
         }*/
            File textFile = new File(newFile, externalfilename);
            FileWriter writer = new FileWriter(textFile);
            for(int x=0;x<readings.size();x++) {
                String temp = Arrays.toString(readings.get(x));
                writer.append(temp.substring(1, temp.length()-1) + "\n");
            }
            writer.flush();
            writer.close();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
    }
    public void startMainActivity(View view)
    {
        finish();
        //Intent intent = new Intent(this, MainActivity.class);
        //startActivity(intent);
    }
}

