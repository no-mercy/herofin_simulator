function addUser(){
  var username = $('.username-input').val()
  if(!username) return;
  $.ajax({
    type: "POST",
    url: "/users",
    data: {name: username},
    success: function() {
      location.reload();
    }
  });
  $('.username-input').val('')
  $('#addUser').modal('hide')
}

function transferMoney(userId){
  var data = {source_user_id: userId};
  data.description = $('.transfer-description').val();
  data.amount = $('.transfer-amount').val();
  data.target_user_id = $('#target_user_id').val();
  if(!data.amount || !data.target_user_id) return;
  $.ajax({
    type: "POST",
    url: "/transfer_money",
    data: data,
    success: function() {
      location.reload();
    }
  });
  $('#transferMoney').modal('hide');
}

function killUser(userId){
  $.ajax({
    type: "DELETE",
    url: "/users/" + userId,
    success: function(){
      location.reload();
    }
  });
  $('#killUser').modal('hide');
}
