let cards = document.getElementsByClassName("gh-card");

function injectStyle(str) {
  let node = document.createElement("style");
  node.innerHTML = str;
  document.body.appendChild(node);
}

function injectStylesheet(url) {
  let node = document.createElement("link");
  node.setAttribute("rel", "stylesheet");
  node.setAttribute("href", url);
  document.body.appendChild(node);
}

function makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * 
 charactersLength));
   }
   return result;
}

let style = `
.gh h4 {
  padding: 0;
  margin: 0;
}

.gh a, .gh a:visited {
  text-decoration: none;
}

.gh links {

}

.gh-small {
  max-width: 300px;
}

.gh-medium {
  max-width: 375px;
}

.gh-large {
  max-width: 450px;
}

.gh-card {
  font-family: 'Arial';
  box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
  transition: 0.3s;
  display: block;
  margin: auto;
  margin-top: 2em;
  border-radius: 5px;
}

.gh-card:hover {
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
}

img.gh {
  border-radius: 5px 5px 0 0;
  width: 100%;
  clip-path: polygon(100% 0, 100% 95%, 50% 100%, 0% 95%, 0 0);
}

img.gh_og {
  width: 100%;
}

.container.gh {
  padding: 16px;
}

.links.gh {
  padding: 1em;
}

.gh p {
  line-height: 1.6;
}
`;

injectStyle(style);

for (let card of cards) {
  let repo = card.getAttribute("repo");
  let image = card.getAttribute("image");
  let url = "https://api.github.com/repos/" + repo;

  fetch(url, { method: "GET" })
    .then((resp) => {
      return resp.json();
    })
    .then((json) => {
      if (image == 'opengraph') {
        let id = makeid(7)
        card.innerHTML = `
        <a class="gh" href="https://github.com/${repo}">
        <img class="gh_og" src="https://opengraph.githubassets.com/${id}/${repo}">
        <div class="gh container">
          <h4 class="gh">
            <i class="fa fa-fw fa-github" aria-hidden="true"></i>
            ${json.name}
          </h4>
        </div>
        </a>
        `;
      }
      else {
        card.innerHTML = `
        <img class="gh" src="${(image)?(image):(json.owner.avatar_url)}">
        <div class="gh container">
          <h4 class="gh">
            <i class="fa fa-fw fa-github" aria-hidden="true"></i>
            ${json.full_name}
          </h4>
          <p class="gh">${json.description}</p>
          <div class="gh" align="center">
          <a class="gh links" href="${json.html_url}/watchers">
            <i class="fa fa-fw fa-eye" aria-hidden="true"></i>
            ${json.subscribers_count}
            <a class="gh links" href="${json.html_url}/network">
              <i class="fa fa-fw fa-code-fork" aria-hidden="true"></i>
              ${json.forks_count}
            </a>
            <a class="gh links" href="${json.html_url}/stargazers">
              <i class="fa fa-fw fa-star" aria-hidden="true"></i>
              ${json.stargazers_count}
            </a>
            </a>
          </div>
        </div>
        `;
        card.addEventListener('click', () => {
          window.open(json.html_url);
        })
        card.style.cursor = "pointer";
      }
    }
    )
    .catch((err) => {
      console.log(err);
    });
}
