package com.wescj.eraser_example;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),
                "com.wescj.eraser_example/app").setMethodCallHandler((call, result) -> {
            if ("moveTaskToBack".equals(call.method)) {
                moveTaskToBack(true);
                result.success(null);
            } else {
                result.notImplemented();
            }
        });
    }
}
