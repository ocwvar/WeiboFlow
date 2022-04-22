package com.ocwvar.weibo_flow.json

import com.google.gson.JsonObject

class Converter {

    /**
     * get json string of a error
     *
     * @param code String error code
     * @param message String error message
     * @return json string
     */
    fun toError(code: String, message: String): String {
        return this.toObject(
            Pair(Keys.Error.KEY_STRING_CODE, code),
            Pair(Keys.Error.KEY_STRING_MSG, message),
        )
    }

    fun toTokenObject(accessToken: String, refreshToken: String, uid: String): String {
        return this.toObject(
            Pair(Keys.Json.KEY_STRING_TOKEN_ACCESS, accessToken),
            Pair(Keys.Json.KEY_STRING_TOKEN_REFRESH, refreshToken),
            Pair(Keys.Json.KEY_STRING_UID, uid),
        )
    }

    /**
     * get json object string with given value pair
     *
     * @param valuePair Pair<KEY, VALUE>
     * @return json string
     */
    fun toObject(vararg valuePair: Pair<String, Any>): String {
        return JsonObject().apply {
            valuePair.forEach { pair: Pair<String, Any> ->
                when(pair.second) {
                    is String -> addProperty(pair.first, pair.second as String)
                    is Boolean -> addProperty(pair.first, pair.second as Boolean)
                    is Int -> addProperty(pair.first, pair.second as Int)
                    else -> throw IllegalArgumentException("unsupported value type: ${pair.second::class.java}")
                }
            }
        }.toString()
    }
}