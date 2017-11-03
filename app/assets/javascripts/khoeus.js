$(document).ready(function(){

    $('#user_cep').blur(function(){
        $.ajax({
            url : 'http://viacep.com.br/ws/' + $('#user_cep').val() + '/json/ ',
            type : 'GET',
            dataType: 'json',
            success: function(data){
                $('#user_address').val(data.logradouro);
                $('#user_neighborhood').val(data.bairro);
                $('#user_city').val(data.localidade);
                $('#user_state').val(data.uf);
                $('#user_country').val('Brasil');

                $('#user_number').focus();
            }
        });
        return false;
    });
    $(document).on('change', '.question-type', function(){
        if(this.value === 'objective'){
            $(this).parents('fieldset').find('.question-alternatives').removeClass('hidden');
        } else if (this.value === 'open-ended'){
            $(this).parents('fieldset').find('.question-alternatives').addClass('hidden');
        }
    });

    if($("#assignment_code").length) {
        var editor = CodeMirror.fromTextArea(document.getElementById('assignment_code'), {
            lineNumbers: true,
            matchBrackets: true,
            theme: "seti",
            mode: "text/x-csrc"
        });
        var mac = CodeMirror.keyMap.default == CodeMirror.keyMap.macDefault;
        CodeMirror.keyMap.default[(mac ? "Cmd" : "Ctrl") + "-Space"] = "autocomplete";

        $(document).on('change','#assignment_code_language', function(){
            editor.setOption("mode", $("#assignment_code_language").val());
        });
        $(document).on('click', '.run-code', function(e){
            e.preventDefault();
            var code = editor.getValue();
            $(".loading").toggleClass('hidden');
            $(".run-result").toggleClass('hidden');
            $.ajax({
                type: "POST",
                url: "/compile",
                dataType: 'json',
                data: {
                    code: editor.getValue(),
                },
                success: function(data)
                {
                    $(".loading").toggleClass('hidden');
                    if(data.result.compile_status == "OK"){
                        if(data.result.run_status.stderr !== ""){
                            $(".run-result code").html(data.result.run_status.stderr.replace(/[\n\r]/g, '<br>'))
                        }
                        $(".run-result code").html(data.result.run_status.output_html.replace(/[\n\r]/g, '<br>'))
                    } else {
                        $(".run-result code").html(data.result.compile_status.replace(/[\n\r]/g, '<br>'))
                    }

                }
            });
        });
    }
    if($("#assignment_evaluation").length) {
        var editor = CodeMirror.fromTextArea(document.getElementById('assignment_evaluation'), {
            lineNumbers: true,
            theme: "seti",
            mode: "text/x-csrc",
            readOnly: "nocursor"
        });
        editor.setValue($("#assignment_evaluation").val().replace(/<br>/g, '\n').trim());
        $('.add-feedback').each(function(index, elem){
            var line_id = elem.id;
            var codeline_arr = line_id.split('-');
            var codeline_id = codeline_arr[1];
            $(elem).popover({
                html : true,
                placement: 'left',
                content: function() {
                    return $("#popover-" + codeline_id + "-content").html();
                }
            }).on('hide.bs.popover', function () {
                $("#code_submission_code_line_"+ codeline_id +"_feedback").val($("#textarea-" + codeline_id).val());
            }).on('shown.bs.popover', function () {
                $("#textarea-" + codeline_id).val($("#code_submission_code_line_"+ codeline_id +"_feedback").val());
            });
        });
    }

});