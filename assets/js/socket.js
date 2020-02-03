import {Socket} from "phoenix"
import { renderComments, renderComment } from './components/comments.js';

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

const createSocket = (topicId) => {

  let channel = socket.channel(`comments:${topicId}`, {})

  channel
    .join()
    .receive("ok", resp => {
      console.log("resp -----------------------")
      console.log(resp)
      renderComments(resp.comments);
    })
    .receive("error", resp => {
      console.log("Unable to join", resp)
    })

  // send new comment
  document.querySelector('button').addEventListener('click', () => {
    const content = document.querySelector('textarea').value;

    channel.push('comment:add', { content: content });
  });

  channel.on(`comments:${topicId}:new`, renderComment)
}

window.createSocket = createSocket;
