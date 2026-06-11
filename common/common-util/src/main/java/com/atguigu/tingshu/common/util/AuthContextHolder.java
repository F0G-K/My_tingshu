package com.atguigu.tingshu.common.util;

/**
 * 获取当前用户信息帮助类
 */
public class AuthContextHolder {

    private static ThreadLocal<Long> userId = new ThreadLocal<Long>();

    public static void setUserId(Long _userId) {
        userId.set(_userId);
    }

    public static Long getUserId() {
        //return userId.get();
        //TODO 未完成登录认证,此处返回值1,应该是动态
        return 1L;
    }

    public static void removeUserId() {
        userId.remove();
    }

}
