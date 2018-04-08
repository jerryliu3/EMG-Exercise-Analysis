package com.dfrobot.angelo.blunobasicdemo;

import android.content.Context;
import android.graphics.Color;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Description;
import com.github.mikephil.charting.components.Legend;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.components.YAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.interfaces.datasets.ILineDataSet;

import java.util.ArrayList;
import java.util.List;

public class ExerciseActivity extends AppCompatActivity implements SensorEventListener {

    private static final String TAG = "ExerciseActivity";

    private SensorManager mSensorManager;
    private Sensor mAccelerometer;

    private RelativeLayout exerciseLayout;
    private LineChart mChart;
    private Thread thread;
    private boolean plotData = true;;
    private EditText test;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_exercise);
        exerciseLayout = (RelativeLayout) findViewById(R.id.exerciseLayout);
        // create line chart
        mChart = (LineChart) findViewById(R.id.linechart);

        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        test = (EditText) findViewById(R.id.error);

        List<Sensor> deviceSensors = mSensorManager.getSensorList(Sensor.TYPE_ALL);
        for(int x=0;x< deviceSensors.size();x++)
        {
            //test.append(deviceSensors.get(x).getName() + "\n");
        }
        if(mAccelerometer != null) {
            mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_GAME);
        }
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
        startPlot();
    }

    public void back(View view){
        finish();
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

    private void addEntry(SensorEvent event) {
        LineData data = mChart.getData();
        if(data != null) {
            ILineDataSet set = data.getDataSetByIndex(0);

            if(set == null) {
                set = createSet();
                data.addDataSet(set);
            }

            data.addEntry(new Entry(set.getEntryCount(), event.values[0] + 5), 0);
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

    @Override
    protected void onPause(){
        super.onPause();
        if(thread != null) {
            thread.interrupt();
        }
        mSensorManager.unregisterListener(this);
    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent){
        if(plotData){
            addEntry(sensorEvent);
            plotData = false;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }
    @Override
    protected void onResume() {
        super.onResume();
        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_GAME);
    }

    @Override
    protected void onDestroy() {
        mSensorManager.unregisterListener(ExerciseActivity.this);
        thread.interrupt();
        super.onDestroy();
    }
}
