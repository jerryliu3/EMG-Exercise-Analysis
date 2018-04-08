package com.dfrobot.angelo.blunobasicdemo;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.content.Intent;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.IntentCompat;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import java.io.File;
import java.io.FileWriter;

import static android.provider.AlarmClock.EXTRA_MESSAGE;

public class MainActivity extends BlunoLibrary {
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
        onCreateProcess();														//onCreate Process by BlunoLibrary
	}
	@Override
	public void onSerialReceived(String theString) {

	}
	@Override
	public void onConectionStateChange(connectionStateEnum theConnectionState) {//Once connection state changes, this function will be called

	}
	public void startTestActivity(View view)
	{
		Intent intent = new Intent(this, TestActivity.class);
		startActivity(intent);
	}

	public void startExerciseActivity(View view)
	{
		Intent intent = new Intent(this, ExerciseActivity.class);
		startActivity(intent);
	}

	public void startHistoryActivity(View view)
	{
		Intent intent = new Intent(this, HistoryActivity.class);
		startActivity(intent);
	}

	public void startLoginActivity(View view)
	{
		Intent intent = new Intent(this, LoginActivity.class);
		startActivity(intent);
	}
	public void quit(View view)
	{
		finish();
		System.exit(0);
	}
}