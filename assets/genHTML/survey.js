function surveyAddRowQuestion(link) {
	var $div = $(link).parent();
	var $template = $("#groupQuestion-template");
	var regex = /lstSurveyQuestion\[\d*\]/g;
	if($div!="undefined") {
		var length = $(".groupQuestion").length;
		var newRow = $template.tmpl();
		var questionNumber = newRow.find("#questionNumber").text();
		newRow.find("#questionNumber").text(questionNumber + " " + (length + 1));
		// Change variable index
		newRow.find("[name*='['][name*='].']").each(function() {
			var name = $(this).attr("name").replace(regex, 'lstSurveyQuestion[' + (length) + ']');
			$(this).attr("name", name);
		});
		$div.before(newRow);
		$.ndvn.formatIntegerForQty($('.ndvn-input-integer'));
	}
};

function surveyRemoveRowQuestion(link) {
	var divRemove = $(link).parent().parent();
	divRemove.remove();
	var regex = /lstSurveyQuestion\[\d*\]/g;
	$(".groupQuestion").each(function(i) {
		// Change header
		var questionNumber = $(this).find("#questionNumber").text().split(" ");
		if (questionNumber.length < 3) {
			var $template = $("#groupQuestion-template");
			var newRow = $template.tmpl();
			questionNumber = newRow.find("#questionNumber").text().split(" ");
		}
		$(this).find("#questionNumber").text(questionNumber[0] + " " + questionNumber[1] + " " + (i + 1));
		// Change variable index
		$(this).find("[name*='['][name*='].']").each(function() {
			var name = $(this).attr("name").replace(regex, 'lstSurveyQuestion[' + i + ']');
			$(this).attr("name", name);
		});
	});
};

function surveyAddRowAnswer(link) {
	var $table = $(link).closest("div").prev("table");
	var $template = $("#groupAnswer-template");
	var regex = /lstSurveyAnswer\[\d*\]/g;
	var regexQuestion = /lstSurveyQuestion\[\d*\]/g;
	if($table!="undefined") {
		var lstSurveyQuestion = $($(link).parent().parent().parent().find("[name*='['][name*='].']")[0]).attr("name").match(regexQuestion)[0];
		var length = $table.find(">tbody>tr").length;
		// SURVEY_MAX_ANSWERS
		if(length < 25) {
			var newRow = $template.tmpl();
			$table.append(newRow);
			$.ndvn.reCalIndex($table); // refresh row index (No.)
			// Change variable index
			$table.find(">tbody>tr").each(function(i) {
				$(this).find("[name*='['][name*='].']").each(function() {
					var name = $(this).attr("name").replace(regex, 'lstSurveyAnswer[' + i + ']');
					name = name.replace(regexQuestion, lstSurveyQuestion);
					$(this).attr("name", name);
				});
			});
			return newRow;
		} else {
			var msg = $.ndvn.getMessage('err.sys.0296').replace("{0}", 25);
			$.ndvn.showAlertModal(msg);
			return;
		}
	}
};

function surveyRemoveRowAnswer(link) {
	var $table = $(link).parents("table:first");
	var $removeRow = $(link).closest("tr");
	$removeRow.remove();
	$.ndvn.reCalIndex($table);
	var regex = /lstSurveyAnswer\[\d*\]/g;
	$table.find(">tbody>tr").each(function(i) {
		$(this).find("[name*='['][name*='].']").each(function() {
			var name = $(this).attr("name").replace(regex, 'lstSurveyAnswer[' + i + ']');
			$(this).attr("name", name);
		});
	});
};


/***/
onSelectMultipleCustomerToSurvey = function(lstSelectedCustomers){
	var lstCurrentCustomer = getCurrentCustomers();
	var tableId = 'groupOutlet';
	if(lstSelectedCustomers.length > 0){
		for(var i = 0; i<lstSelectedCustomers.length; i++){
			var data = lstSelectedCustomers[i];
			var customerId = data[0];
			var customerCode = data[1];
			var customerName = data[2];
			if(lstCurrentCustomer.indexOf(customerId) == -1){
				var newRow = addRowJSReturn(tableId);
				$(newRow).find('select[name$=targetCode]').val('99');
				$(newRow).find('input[type=hidden][name$=targetType]').val('00');
				$(newRow).find('input[type=text][name$=targetIdAutocomplete]').val(customerCode);
				$(newRow).find('input[type=text][name$=targetIdAutocomplete]').attr('arg02', '99');
				$(newRow).find('input[type=hidden][name$=targetId]').val(customerId);
				$(newRow).find('td.nameGroupCustomer').html(customerName);
				$(newRow).find('td.nameGroupCustomer').append('<input type="hidden" name="lstSurveyTargets[].name" value="'+customerName+'"/>');
			}
		}
		$.ndvn.recalculate(tableId);
	}
}

changeCodeGroupCustomerSurvey = function(event){
	var thisObj = event.target;
	var codeName = $(thisObj).next("input[type=hidden]").attr('output01');
	var trObj = $(thisObj).closest("tr");
	var indexOfList = $(trObj).attr('data-ar-rindex');
	trObj.each(function(){
		if(typeof codeName !== typeof undefined && codeName.length > 0){
			$(this).find('td.nameGroupCustomer').html(codeName);
			$(this).find('td.nameGroupCustomer').append('<input type="hidden" name="lstSurveyTargets['+indexOfList+'].name" value="'+codeName+'"/>');
		}else{
			$(this).find('td.nameGroupCustomer').html('');
		}
	});
}