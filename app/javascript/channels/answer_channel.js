import consumer from "./consumer"

consumer.subscriptions.create("AnswerChannel", {
  connected() {
    var questionId = $('.question').data('question-id');
    this.perform('follow', { question_id: questionId });
  },

  received(data) {
    var answers = $('.answers');

    if (data['answer']['user_id'] !== gon.user_id) {
      var answer = renderAnswer(data['answer'], data['question_author']);
      var li = document.createElement('li');
      li.classList.add('answer-' + data['answer']['id']);
      li.innerHTML = answer;
      answers.append(li);  
    }
  }
});

function renderAnswer(answer, question_author) {
  var sections = ``;

  sections += `
    <p>${answer['body']}</p>
    <h3 class="rating">Rating: 0</h3>
  `;

  if (answer['user_id'] != gon.user_id) {
    var votes = `
      <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/positive">Positive</a>
      <a>|</a>
      <a data-type="json" data-remote="true" rel="nofollow" data-method="post" href="/answers/${answer['id']}/negative">Negative</a>
      <br>
    `;

    sections += votes;
  };


  if (question_author.id == gon.user_id) {
    var bestButton = `
      <button type="button" data-remote="true" rel="nofollow" data-method="patch" href="/answers/${answer['id']}/best">Best answer</button>
      <br>
    `;

    sections += bestButton;
  };

  if (answer['user_id'] == gon.user_id) {
    var  remoteAnswer = `
      <a data-answer-id="${answer['id']}" class="edit-answer-link" href="#">Edit</a>
      <a>|</a>
      <a data-answer-id="${answer['id']}" data-remote="true" class="delete-answer-link" rel="nofollow" data-method="delete" href="/answers/${answer['id']}">Delete</a>
    `;

    sections += remoteAnswer;
  };

  var form = `
    <form class="hidden" id="edit-answer-${answer['id']}" enctype="multipart/form-data" action="/answers/${answer['id']}" accept-charset="UTF-8" data-remote="true" method="post">
      <input type="hidden" name="_method" value="patch">
      <div class="form-group">
        <label for="answer_body">Your answer</label>
        <textarea class="form-control" name="answer[body]" id="answer_body">${answer['body']}</textarea>
      </div>
      <div class="form-group">
        <label for="answer_files">Files</label>
        <input multiple="multiple" class="form-control" data-direct-upload-url="http://localhost:3000/rails/active_storage/direct_uploads" type="file" name="answer[files][]" id="answer_files">
      </div>
      <div class="form-group">
        <div class="links">
          <a class="add_fields" data-association="link" data-associations="links" data-association-insertion-template="<div class=&quot;nested-fields&quot;>
            <div class=&quot;field&quot;><label for=&quot;answer_links_attributes_new_links_name&quot;>Link name</label>
              <input type=&quot;text&quot; name=&quot;answer[links_attributes][new_links][name]&quot; id=&quot;answer_links_attributes_new_links_name&quot; />
            </div>
            <div class=&quot;field&quot;><label for=&quot;answer_links_attributes_new_links_url&quot;>Url</label>
              <input type=&quot;text&quot; name=&quot;answer[links_attributes][new_links][url]&quot; id=&quot;answer_links_attributes_new_links_url&quot; />
            </div><input value=&quot;false&quot; type=&quot;hidden&quot; name=&quot;answer[links_attributes][new_links][_destroy]&quot; id=&quot;answer_links_attributes_new_links__destroy&quot; />
              <a class=&quot;remove_fields dynamic&quot; href=&quot;#&quot;>Remove link</a>
            </div>" href="#">Add link</a>
        </div>
      </div>
      <input type="submit" name="commit" value="Save" class="btn btn-primary" data-disable-with="Save">
    </form>
  </div>
  `;

  sections += form;

  return sections;
};