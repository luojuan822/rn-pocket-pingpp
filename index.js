
import {NativeModules, Platform, NativeAppEventEmitter} from 'react-native';
//console.log(NativeModules)
// var invariant = require('invariant');
const { PingPayManager } = NativeModules;

// console.log("PingPayManager===========");
// console.log(PingPayManager);

var savedCallback = undefined;
NativeAppEventEmitter.addListener('Pingpp_Resp', resp => {
    console.log('savedCallback====addListener====begin===', savedCallback);
    const callback = savedCallback;
    savedCallback = undefined;
    callback && callback(resp);
    console.log('savedCallback====addListener====end===', resp);
});

function waitForResponse() {
    return new Promise((resolve, reject) => {
        console.log('savedCallback====waitForResponse====begin===', savedCallback);
        if (savedCallback) {
            savedCallback('User canceled.');
        }
        savedCallback = r => {
            savedCallback = undefined;
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