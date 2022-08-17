import consumer from "./consumer"

consumer.subscriptions.create("CommentChannel", {
  connected() {
    var answerId = $('.answer').data('answer-id');
    var questionId = $('.question').data('question-id');

    this.perform('follow', {
       answer_id: answerId,
       question_id: questionId
    });
  },

  received(data) {
    var type = data['resource'];
    var resource = $('.' + type + '-' + 'comments');

    if (data['comment']['user_id'] !== gon.user_id) {
      var comment = renderComment(data['comment'], data['user_email']);

      resource.append(comment);
    };
  }
});

function renderComment(comment, user_email) {
  var sections = `
  <div class="comment">
    <p>${comment['content']}</p> 
    <p>Author: ${user_email}</p>
  `;

  sections += '</div>'
  return sections;
};