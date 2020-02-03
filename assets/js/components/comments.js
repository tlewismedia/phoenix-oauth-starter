

function formatDate(input) {
  const epoch = Date.parse(input)
  let date = new Date(0);
  date.setUTCMilliseconds(epoch);

  const options = {
    year: 'numeric', month: 'numeric', day: 'numeric',
    hour: 'numeric', minute: 'numeric', second: 'numeric',
    timeZone: 'America/Los_Angeles'
  };

  return new Intl.DateTimeFormat('en-US', options).format(date)
}

function commentTemplate(comment) {
  let email = 'Anonymous';
  if (comment.user) {
    email = comment.user.email;
  }

  return `
    <li class="cmt__li">

      <div class="cmt__user_dt">
        <div class="cmt__user">
          ${email}
        </div>

        <div class="cmt__datetime">${formatDate(comment.inserted_at)}</div>
      </div>

      <div class="cmt__content">
        ${comment.content}
      </div>



    </li>
  `;
}

export function renderComments(comments) {
  const renderedComments = comments.map( comment => {
    return commentTemplate(comment);
  });

  document.querySelector('.collection').innerHTML = renderedComments.join('');
}

export function renderComment(event) {
  const renderedComment = commentTemplate(event.comment)

  document.querySelector('.collection').innerHTML += renderedComment;
}
