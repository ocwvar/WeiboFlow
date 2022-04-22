package com.ocwvar.weibo_flow.weibo

import android.app.Activity
import android.content.Context
import com.ocwvar.weibo_flow.BuildConfig
import com.ocwvar.weibo_flow.json.Keys
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
        val cachedToken: Map<String, String>? = getCachedToken()
        if (cachedToken != null) {
            // if we have cache
            Status.tokenAccess = cachedToken[Keys.Json.KEY_STRING_TOKEN_ACCESS] ?: ""
            Status.tokenRefresh = cachedToken[Keys.Json.KEY_STRING_TOKEN_REFRESH] ?: ""
            Status.authUid = cachedToken[Keys.Json.KEY_STRING_UID] ?: ""
            callback.invoke(true, false, null, -1)
            return
        }

        this.authorizeCallback = callback
        this.api.setLoggerEnable(BuildConfig.DEBUG)
        this.api.authorizeWeb(activity, this)
    }

    /**
     * delete sp cache
     */
    fun deleteCaches() {
        val editor = this.applicationContext.getSharedPreferences(Keys.SP_FILE_NAME, Context.MODE_PRIVATE).edit()
        editor.clear()
        editor.apply()
    }

    /**
     * cache all tokens into sp
     */
    private fun cacheTokens(accessToken: String, refreshToken: String, uid: String) {
        val editor = this.applicationContext.getSharedPreferences(Keys.SP_FILE_NAME, Context.MODE_PRIVATE).edit()
        editor.putString(Keys.Json.KEY_STRING_TOKEN_ACCESS, accessToken)
        editor.putString(Keys.Json.KEY_STRING_TOKEN_REFRESH, refreshToken)
        editor.putString(Keys.Json.KEY_STRING_UID, uid)
        editor.apply()
    }

    /**
     * get cached tokens from sp
     * @return token mapping, null if there is no cache or cache not complete
     */
    private fun getCachedToken() : Map<String, String>? {
        val sp = this.applicationContext.getSharedPreferences(Keys.SP_FILE_NAME, Context.MODE_PRIVATE)
        val accessToken: String = sp.getString(Keys.Json.KEY_STRING_TOKEN_ACCESS, "") ?: ""
        val refreshToken: String = sp.getString(Keys.Json.KEY_STRING_TOKEN_REFRESH, "") ?: ""
        val uid: String = sp.getString(Keys.Json.KEY_STRING_UID, "") ?: ""
        if (accessToken.isEmpty() || refreshToken.isEmpty() || uid.isEmpty()) {
            // no cache or not complete
            return null
        }

        return mapOf(
            Pair(Keys.Json.KEY_STRING_TOKEN_ACCESS, accessToken),
            Pair(Keys.Json.KEY_STRING_TOKEN_REFRESH, refreshToken),
            Pair(Keys.Json.KEY_STRING_UID, uid),
        )
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

        // cache them to sp
        this.cacheTokens(token.accessToken, token.refreshToken, token.uid);

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