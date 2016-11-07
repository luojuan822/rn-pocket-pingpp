
import {NativeModules, Platform, NativeAppEventEmitter, NativeEventEmitter} from 'react-native';
//console.log(NativeModules)
var invariant = require('invariant');
const { PingPayManager } = NativeModules;

console.log("PingPayManager===========");
console.log(PingPayManager);

var savedCallback = undefined;

if (Platform.OS === 'ios') {
    invariant(PingPayManager, 'ios failure');
    const myNativeEvt = new NativeEventEmitter(PingPayManager);  //创建自定义事件接口  
    myNativeEvt.addListener('Pingpp_Resp', resp => {
        console.log('savedCallback====addListener====begin===', savedCallback);
        const callback = savedCallback;
        savedCallback = undefined;
        callback && callback(resp);
        console.log('savedCallback====addListener====end===', resp);
    });
} else if (Platform.OS === 'android') {
    invariant(PingPayManager, 'android failure');

    NativeAppEventEmitter.addListener('Pingpp_Resp', resp => {
        console.log('savedCallback====addListener====begin===', savedCallback);
        const callback = savedCallback;
        savedCallback = undefined;
        callback && callback(resp);
        console.log('savedCallback====addListener====end===', resp);
    });
} else {
    invariant(PingPayManager, "Invalid platform");
}


function waitForResponse() {
    return new Promise((resolve, reject) => {
        console.log('savedCallback====waitForResponse====begin===', savedCallback);
        if (savedCallback) {
            savedCallback('User canceled.');
        }
        savedCallback = r => {
            savedCallback = undefined;
            console.log('savedCallback====waitForResponse====resolve===', r);
            resolve(r);
            // const {result, errCode, errMsg} = r;

            // if (result && result === 'success') {
            //     resolve(result);
            //     console.log('savedCallback====waitForResponse====resolve===', result);
            // }
            // else {
            //     const err = new Error(errMsg);
            //     err.errCode = errCode;
            //     reject(err);
            //     console.log('savedCallback====waitForResponse====reject===', err);
            // }
        };
    });
}

export async function pay(charge){
    if(typeof charge === 'string') {
        PingPayManager.pay(charge);
    }
    else {
        PingPayManager.pay(JSON.stringify(charge));
    }
    return await waitForResponse();
}