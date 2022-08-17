import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    this.perform('question_channel');
  },

  received(data) {
    $('.questions').append(data);
  }
});