package com.dfrobot.angelo.blunobasicdemo;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.os.Environment;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;


public class TestActivity extends BlunoLibrary {
    private Button buttonScan;
    private Button buttonSerialSend;
    private Button buttonSerialRead;
    private EditText serialSendText;
    private TextView serialReceivedText;
    private ArrayList<int[]> readings;
    private LineChart mChart;
    private Thread thread;
    private boolean plotData = true;;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_test);
        onCreateProcess();                                        //onCreate Process by BlunoLibrary


        serialBegin(115200);                                       //set the Uart Baudrate on BLE chip to 115200

        serialReceivedText=(TextView) findViewById(R.id.serialReceivedText);   //initial the EditText of the received data
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

        // create line chart
        mChart = (LineChart) findViewById(R.id.linechart);

        mChart.getDescription().setEnabled(true);
        mChart.getDescription().setText("Real Time Accelerometer Data Plot");
        //mChart.setNoDataText("No data for the moment");

        //enable touch gesures
        mChart.setTouchEnabled(false);

        //we also want to enable scaling and dragging
        mChart.setDragEnabled(true);
        mChart.setScaleEnabled(true);
        mChart.setDrawGridBackground(false);

        // enable pinch zoom to avoid scaling x and y axis separately
        mChart.setPinchZoom(false);

        //alternative background color
        mChart.setBackgroundColor(Color.WHITE);

        LineData data = new LineData();
        data.setValueTextColor(Color.WHITE);
        mChart.setData(data);

        // get legend object
        Legend l = mChart.getLegend();

        // custom legend
        l.setForm(Legend.LegendForm.LINE);
        l.setTextColor(Color.WHITE);

        XAxis x1 = mChart.getXAxis();
        x1.setTextColor(Color.WHITE);
        x1.setDrawGridLines(true);
        x1.setAvoidFirstLastClipping(true);
        x1.setEnabled(true);

        YAxis leftAxis = mChart.getAxisLeft();
        leftAxis.setTextColor(Color.WHITE);
        leftAxis.setAxisMaxValue(10f);
        leftAxis.setAxisMinimum(0f);
        leftAxis.setDrawGridLines(true);

        YAxis y12 = mChart.getAxisRight();
        y12.setEnabled(false);

        mChart.getAxisLeft().setDrawGridLines(false);
        mChart.getXAxis().setDrawGridLines(false);
        mChart.setDrawBorders(false);


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
                    //serialReceivedText.append(splitString[x]+"\n");
                    temp[x] = Integer.parseInt(splitString[x]);
                    if(plotData){
                        addEntry(temp[x]);
                    }
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

    private void startPlot(){
        if(thread != null){
            thread.interrupt();
        }
        thread = new Thread(new Runnable() {
            @Override
            public void run() {
                while(true){
                    plotData = true;
                    try{
                        Thread.sleep(25);
                    }
                    catch(InterruptedException e)
                    {
                        e.printStackTrace();
                    }
                }
            }
        });

        thread.start();
    }

    private void addEntry(int event) {
        LineData data = mChart.getData();
        if(data != null) {
            ILineDataSet set = data.getDataSetByIndex(0);

            if(set == null) {
                set = createSet();
                data.addDataSet(set);
            }

            data.addEntry(new Entry(set.getEntryCount(), event), 0);
            data.notifyDataChanged();
            mChart.notifyDataSetChanged();
            mChart.setVisibleXRangeMaximum(150);
            mChart.moveViewToX(data.getEntryCount());
        }
    }

    private LineDataSet createSet(){
        LineDataSet set = new LineDataSet(null, "Dynamic Data");
        set.setAxisDependency(YAxis.AxisDependency.LEFT);
        set.setLineWidth(3f);
        set.setColor(Color.MAGENTA);
        set.setHighlightEnabled(false);
        set.setDrawValues(false);
        set.setDrawCircles(false);
        set.setMode(LineDataSet.Mode.CUBIC_BEZIER);
        set.setCubicIntensity(0.2f);
        return set;
    }
}

