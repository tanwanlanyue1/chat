

async function _callAppMethod(method, context, args = {}){
    if(window.__js_bridge__ && __js_bridge__.postMessage){
        return new Promise(function(resolve, reject){
            const _uuid = Date.now();
            __js_bridge__.postMessage(JSON.stringify({
                'method': method,
                'uuid': _uuid,
                ...args,
            }));
            let timeoutId;
            let timeout = 8000;
            if(typeof args.timeout == 'number'){
                timeout = args.timeout;
            }
            if(timeout > 0){
                timeoutId = setTimeout(() => {
                    console.log('method:', method, ' call timeout!');
                    reject('timeout');
                }, timeout);
            }
            context[`${method}Return`] = function(data, uuid){
                if(uuid == _uuid){
                    if(timeoutId){
                        clearTimeout(timeoutId);
                    }
                    resolve(data);
                }
            }
        });
    }
    return null;
}

(function(context){

    /**
     * 获取http请求头
     * @returns
     */
    context.getRequestHeaders = () => _callAppMethod('getRequestHeaders', context);

     /**
     * 获取AccessToken
     * @returns {userId: 122, token: 'xxx'}
     */
     context.getAccessToken = () => _callAppMethod('getAccessToken', context);

     /**
     * 获取用户信息
     * @returns
     */
     context.getUserInfo = () => _callAppMethod('getUserInfo', context);

     /**
     * 获取用户绑定信息
     * @returns
     */
     context.getBinding = () => _callAppMethod('getBinding', context);

      /**
      * 显示提示消息
      */
      context.showToast = (message) => _callAppMethod('showToast', context, {message});

      /**
        * 显示Loading
       */
       context.showLoading = (message = '') => _callAppMethod('showLoading', context, {message});

       /**
        * 隐藏Loading
        */
       context.hideLoading = () => _callAppMethod('hideLoading', context);

      /**
       * 页面跳转
       */
      context.goto = (path, args = {}) => _callAppMethod('goto', context, {path, ...args});

      /**
       * 关闭页面
       */
      context.goBack = () => _callAppMethod('goBack', context);

      /**
       * 复制文字
       */
      context.copyText = (message = '') => _callAppMethod('copyText', context, {message});

      /**
       * 注销后清除缓存
       */
      context.clearCache = () => _callAppMethod('clearCache', context);

      /**
       * 保存图片到相册
       */
      context.saveGallery = (url) => _callAppMethod('saveGallery', context, {url});

      /**
       * 佛珠滚了一圈
       */
      context.onBeadsIncrement = () => _callAppMethod('onBeadsIncrement', context);

      /**
       * 获取邮箱验证码
       */
     context.emailVerify = () => _callAppMethod('emailVerify', context, {timeout: 0});

      /**
       * 获取短信验证码
       * return verificationId | "false"
       */
     context.phoneVerify = () => _callAppMethod('phoneVerify', context, {timeout: 0});

       /**
        * 账号注销
        */
     context.accountCancellation = (verificationId = '', smsCode = '',type = 0,phone = true) => _callAppMethod('accountCancellation', context, {verificationId, smsCode,type,phone});

})(window.JSBridge = {});
