'use strict';

const Alexa = require('alexa-sdk');
const AWS = require('aws-sdk');
const docClient = new AWS.DynamoDB.DocumentClient()
const alexaAppId = process.env.ALEXA_APPLICATION_ID
const SLEEP = '<break time="300ms"/>';

exports.handler = function(event, context, callback) {

    console.log(JSON.stringify(event));

    //Amazon Developer Console でのTestへ対応
    if(event.context && event.context.System.application.applicationId == 'applicationId'){
	    event.context.System.application.applicationId = event.session.application.applicationId;
    }

    var alexa = Alexa.handler(event, context);
    alexa.appId = alexaAppId;
    alexa.registerHandlers(handlers);
    alexa.execute();
};

const handlers = {
  'NewSession': function () {
    this.emit('HelloIntent');
  },
  'Unhandled': function () {
    this.emit('HelloIntent');
  },
  'HelloIntent': function () {
    // UserIdからシークレット・キーの生成
    let userId = this.event.context.System.user.userId;
    // 取り合えずUserIdの一部（10文字）にしてみる
    let secretKey = userId.split('.')[3].slice(0,10).toLowerCase(); 

    let self = this;
    // シークレット・キーをKeyとしてDynamoDBを検索する
    let params = {
      TableName: "CooperationByDynamoDBTable",
      Key:{
          "SecretKey": secretKey,
      }
    };
    docClient.get(params, function(err, data) {
      let name = '';
      let pin = '';
      if (err) {
          console.error("Unable to read item. Error JSON:", JSON.stringify(err, null, 2));
      } else {
        if (typeof data.Item === "undefined") {
            console.log('😭 Not found')
        } else {
          // TTLの期限確認
          let date = new Date();
          let now = Math.floor( date.getTime() / 1000 )
          let ttl = data.Item.Ttl;
          if( (now - ttl) < 0) { // TTLが期限を過ぎていない場合、これを利用する
            pin = data.Item.Pin
            name = data.Item.Name
          }
        }
      }
      if (pin != '') {
        self.emit(':tell',name + 'さんの暗証番号を確認しました。暗証番号は' + SLEEP + pin + SLEEP + 'です');
      } else {
        self.emit(':tell', 'アプリを起動して、シークレット・キーを入力して下さい。' + SLEEP + 'シークレット・キーは、' + SLEEP +　readSecretKey(secretKey) + SLEEP + 'です。');
      }
    });
  }
};

function readSecretKey(secretKey) {
  let result = '';
  secretKey.split('').forEach(function (c) {
    if('0' <= c && c <='9'){
      result += '数字の、';
    } else if('A' <= c && c <='Z') {
      result += 'アルファベットの、';
    }
    result += c;
    result += '、';
  });
  return result;
}