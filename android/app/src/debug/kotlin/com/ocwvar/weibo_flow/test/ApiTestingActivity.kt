package com.ocwvar.weibo_flow.test

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Bundle
import android.view.View
import android.widget.TextView
import com.ocwvar.weibo_flow.R
import com.ocwvar.weibo_flow.weibo.WBApi

class ApiTestingActivity : Activity() {

    private lateinit var status: TextView

    @SuppressLint("SetTextI18n")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_test_api)
        this.status = findViewById(R.id.test_status)

        findViewById<View>(R.id.test_register).setOnClickListener {
            WBApi.initWBApi(this) { success: Boolean ->
                status.text = "Register status: $success"
            }
        }

        findViewById<View>(R.id.test_auth).setOnClickListener {
            WBApi.authWEBApi(this) { success, isCanceled, errorMessage, errorCode ->
                if (success) {
                    status.text = "AuthorizeWeb was succeed !"
                    return@authWEBApi
                }

                status.text = "AuthorizeWeb was failed. Was canceled: $isCanceled\n Message:$errorMessage\n Code:$errorCode"
            }
        }
    }

}