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
});