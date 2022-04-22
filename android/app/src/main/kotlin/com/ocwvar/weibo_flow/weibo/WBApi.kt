package com.ocwvar.weibo_flow.weibo

import android.app.Activity
import android.content.Context
import com.ocwvar.weibo_flow.BuildConfig
import com.sina.weibo.sdk.auth.AuthInfo
import com.sina.weibo.sdk.auth.Oauth2AccessToken
import com.sina.weibo.sdk.auth.WbAuthListener
import com.sina.weibo.sdk.common.UiError
import com.sina.weibo.sdk.openapi.IWBAPI
import com.sina.weibo.sdk.openapi.SdkListener
import com.sina.weibo.sdk.openapi.WBAPIFactory
import java.lang.Exception

object WBApi : SdkListener, WbAuthListener {

    object Status {
        internal var initSucceed: Boolean? = null
        internal var tokenAccess: String = ""
        internal var tokenRefresh: String = ""
        internal var authUid: String = ""

        val isInitSucceed: Boolean
        get() = this.initSucceed == true

        val hasToken: Boolean
        get() = this.tokenAccess.isNotEmpty() && this.tokenRefresh.isNotEmpty() && this.authUid.isNotEmpty()

        val tokenOfAccess: String
        get() = this.tokenAccess

        val tokenOfRefresh: String
        get() = this.tokenRefresh

        val uid: String
        get() = this.authUid
    }

    // application context
    private lateinit var applicationContext: Context

    // weibo api interface
    // init in [initWEApi()]
    private lateinit var api: IWBAPI

    // callback for [SdkListener]
    private var initCallback: ((success: Boolean) -> Unit)? = null

    // callback for [WbAuthListener]
    private var authorizeCallback: ((success: Boolean, isCanceled: Boolean, errorMessage: String?, errorCode: Int) -> Unit)? = null

    /**
     * init weibo api
     */
    fun initWBApi(context: Context, callback: (success: Boolean) -> Unit) {
        this.initCallback = callback
        this.applicationContext = context.applicationContext
        this.api = WBAPIFactory.createWBAPI(this.applicationContext)
        val authInfo = AuthInfo(
            this.applicationContext,
            BuildConfig.WEIBO_APP_KEY,
            BuildConfig.WEIBO_REDIRECT_URL,
            BuildConfig.WEIBO_SCOPE
        )
        this.api.registerApp(this.applicationContext, authInfo, this)
    }

    /**
     * Auth with user token
     */
    fun authWEBApi(activity: Activity, callback: (success: Boolean, isCanceled: Boolean, errorMessage: String?, errorCode: Int) -> Unit) {
        this.authorizeCallback = callback
        this.api.setLoggerEnable(true)
        this.api.authorizeWeb(activity, this)
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////// INTERFACE FUNCTIONS ///////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////

    //// for [this.api.registerApp]

    /**
     * callback for [IWBAPI.registerApp]
     * if succeed, will never call this again
     */
    override fun onInitSuccess() {
        Status.initSucceed = true
        this.initCallback?.invoke(true)
        this.initCallback = null
    }

    /**
     * on register failed
     */
    override fun onInitFailure(p0: Exception?) {
        Status.initSucceed = false
        this.initCallback?.invoke(false)
        this.initCallback = null
    }

    //// for [this.api.authorize]

    /**
     * on user authorize success
     * @param token Oauth2AccessToken All token information
     */
    override fun onComplete(token: Oauth2AccessToken?) {
        if (token == null) {
            this.authorizeCallback?.invoke(false, false, "onComplete() token object is null", -1)
            this.authorizeCallback = null
            return
        }
        // get all token we need
        Status.tokenAccess = token.accessToken
        Status.tokenRefresh = token.refreshToken
        Status.authUid = token.uid

        if (!Status.hasToken) {
            this.authorizeCallback?.invoke(false, false, "onComplete() token string is null", -1)
            this.authorizeCallback = null
            return
        }

        // all passed !!
        this.authorizeCallback?.invoke(true, false, null, -1)
        this.authorizeCallback = null
    }

    /**
     * on authorize has error
     */
    override fun onError(error: UiError?) {
        this.authorizeCallback?.invoke(false, false, "${error?.errorMessage}  ${error?.errorDetail}", error?.errorCode ?: -1)
        this.authorizeCallback = null
    }

    /**
     * on user canceled authorize
     */
    override fun onCancel() {
        this.authorizeCallback?.invoke(false, true, null, -1)
        this.authorizeCallback = null
    }

}