// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require cocoon
//= require bootstrap
//= require bootstrap-combobox
//= require moment
//= require moment/zh-cn
//= require bootstrap-datetimepicker
//= require_tree .

function convertCurrency(currencyDigits) {
  // Constants:
  var MAXIMUM_NUMBER = 99999999999.99;
  // Predefine the radix characters and currency symbols for output:
  var CN_ZERO = "零";
  var CN_ONE = "壹";
  var CN_TWO = "贰";
  var CN_THREE = "叁";
  var CN_FOUR = "肆";
  var CN_FIVE = "伍";
  var CN_SIX = "陆";
  var CN_SEVEN = "柒";
  var CN_EIGHT = "捌";
  var CN_NINE = "玖";
  var CN_TEN = "拾";
  var CN_HUNDRED = "佰";
  var CN_THOUSAND = "仟";
  var CN_TEN_THOUSAND = "万";
  var CN_HUNDRED_MILLION = "亿";
  var CN_SYMBOL = "人民币";
  var CN_DOLLAR = "元";
  var CN_TEN_CENT = "角";
  var CN_CENT = "分";
  var CN_INTEGER = "整";
  // Variables:
  var integral;
  // Represent integral part of digit number.
  var decimal;
  // Represent decimal part of digit number.
  var outputCharacters;
  // The output result.
  var parts;
  var digits, radices, bigRadices, decimals;
  var zeroCount;
  var i, p, d;
  var quotient, modulus;
  // Validate input string:
  currencyDigits = currencyDigits.toString();
  if (currencyDigits == "") {
    alert("Empty input!");
    return "";
  }
  if (currencyDigits.match(/[^,.\d]/) != null) {
    alert("Invalid characters in the input string!");
    return "";
  }
  if (currencyDigits.match(/^((\d{1,3}(,\d{3})*(.((\d{3},)*\d{1,3}))?)|(\d+(.\d+)?))$/) == null) {
    alert("Illegal format of digit number!");
    return "";
  }
  // Normalize the format of input digits:
  currencyDigits = currencyDigits.replace(/,/g, "");
  // Remove comma delimiters.
  currencyDigits = currencyDigits.replace(/^0+/, "");
  // Trim zeros at the beginning.
  // Assert the number is not greater than the maximum number.
  if (Number(currencyDigits) > MAXIMUM_NUMBER) {
    alert("Too large a number to convert!");
    return "";
  }
  // Process the coversion from currency digits to characters:
  // Separate integral and decimal parts before processing coversion:
  parts = currencyDigits.split(".");
  if (parts.length > 1) {
    integral = parts[0];
    decimal = parts[1];
    // Cut down redundant decimal digits that are after the second.
    decimal = decimal.substr(0, 2);
  } else {
    integral = parts[0];
    decimal = "";
  }
  // Prepare the characters corresponding to the digits:
  digits = new Array(CN_ZERO, CN_ONE, CN_TWO, CN_THREE, CN_FOUR, CN_FIVE, CN_SIX, CN_SEVEN, CN_EIGHT, CN_NINE);
  radices = new Array("", CN_TEN, CN_HUNDRED, CN_THOUSAND);
  bigRadices = new Array("", CN_TEN_THOUSAND, CN_HUNDRED_MILLION);
  decimals = new Array(CN_TEN_CENT, CN_CENT);
  // Start processing:
  outputCharacters = "";
  // Process integral part if it is larger than 0:
  if (Number(integral) > 0) {
    zeroCount = 0;
    for (i = 0; i < integral.length; i++) {
      p = integral.length - i - 1;
      d = integral.substr(i, 1);
      quotient = p / 4;
      modulus = p % 4;
      if (d == "0") {
        zeroCount++;
      } else {
        if (zeroCount > 0) {
          outputCharacters += digits[0];
        }
        zeroCount = 0;
        outputCharacters += digits[Number(d)] + radices[modulus];
      }
      if (modulus == 0 && zeroCount < 4) {
        outputCharacters += bigRadices[quotient];
      }
    }
    outputCharacters += CN_DOLLAR;
  }
  // Process decimal part if there is:
  if (decimal != "") {
    for (i = 0; i < decimal.length; i++) {
      d = decimal.substr(i, 1);
      if (d != "0") {
        outputCharacters += digits[Number(d)] + decimals[i];
      }
    }
  }
  // Confirm and return the final output string:
  if (outputCharacters == "") {
    outputCharacters = CN_ZERO + CN_DOLLAR;
  }
  if (decimal == "") {
    outputCharacters += CN_INTEGER;
  }
  outputCharacters = CN_SYMBOL + outputCharacters;
  return outputCharacters;
}

// 发送ajax请求
  function send_ajax (url, pid, post_data) {
    $.ajax({
      type: "POST",
      url: url,
      data: post_data,
      success: function(data){  
        alert(data.msg);
        // $(".state_"+pid).text(data.state);
        location.reload();
      }
    });
  }

$(document).ready(function() {
  console.log(current_controller);
  console.log(current_action);

  // 初始化日历控件
  $('.datetimepicker4').datetimepicker({
    format: "YYYY-MM-DD",
    calendarWeeks: true
  });

  // 重置查询条件
  $('form').on("click", "#search_reset", function(){
    var form_node = $(this).parents("form")
    form_node.find("input").val("");
    form_node.find("select").val("");
    // return false;
  })

  switch (current_controller) {
    case "orders":
      switch (current_action) {
        case "index":
          // orders index
          // 点击提交审核按钮
          $("button.to_pand").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_pand";
            send_ajax(url, pid, "");
          });

          // 点击审核通过按钮
          $("button.pand_pass").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/pand_pass";
            send_ajax(url, pid, "");
          });

          // 点击审核驳回按钮
          $("button.pand_back").on("click", function(){
            var reason = prompt("请输入审核驳回理由！","")
            if ($.trim(reason) == "") {
              alert("审核驳回理由不能为空！");
              return false;
            };
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/pand_back";
            send_ajax(url, pid, {"reason": reason});
          });

          // 点击发货按钮
          $("button.to_deliver").on("click", function(){
            var shipment_code = prompt("请输入物流编号！","")
            if ($.trim(shipment_code) == "") {
              alert("物流编号不能为空！");
              return false;
            };
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_deliver";
            send_ajax(url, pid, {"shipment_code": shipment_code});
          });

          // 点击作废按钮
          $("button.to_cancel").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_cancel";
            send_ajax(url, pid, "");
          });
          break;
        case "show":
          // orders show
          $(".traditional_price").text(convertCurrency(totle_sum));

          // 点击提交审核按钮
          $("button.to_pand").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_pand";
            send_ajax(url, pid, "");
          });

          // 点击审核通过按钮
          $("button.pand_pass").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/pand_pass";
            send_ajax(url, pid, "");
          });

          // 点击审核驳回按钮
          $("button.pand_back").on("click", function(){
            var reason = prompt("请输入审核驳回理由！","")
            if ($.trim(reason) == "") {
              alert("审核驳回理由不能为空！");
              return false;
            };
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/pand_back";
            send_ajax(url, pid, {"reason": reason});
          });

          // 点击发货按钮
          $("button.to_deliver").on("click", function(){
            var shipment_code = prompt("请输入物流编号！","")
            if ($.trim(shipment_code) == "") {
              alert("物流编号不能为空！");
              return false;
            };
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_deliver";
            send_ajax(url, pid, {"shipment_code": shipment_code});
          });

          // 点击作废按钮
          $("button.to_cancel").on("click", function(){
            var pid = $(this).attr("p-id");
            var url = "/orders/"+pid+"/to_cancel";
            send_ajax(url, pid, "");
          });
          break;
        default:
          // orders default
      };

      break;
    default:
      alert('>41');
  };
});