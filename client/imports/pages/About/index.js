import React from "react";
import { Link } from "react-router-dom";
import GithubIcon from "react-icons/lib/fa/github";
import AngellistIcon from "react-icons/lib/fa/angellist";
import LinkedinIcon from "react-icons/lib/fa/linkedin";
import StackOverflowIcon from "react-icons/lib/fa/stack-overflow";
import EnvelopeIcon from "react-icons/lib/fa/envelope";

class About extends React.Component {
  componentWillMount() {
    document.title = "about | jordan garside";
  }
  render() {
    return (
      <div className="about-container template-container">
        <div className="inner-container">
          <h1>About Me</h1>

          <p>
            Currently working on{" "}
            <a href="https://about.cloudszi.com/">cloudszi</a>.
          </p>

          <p>Made simple scripts in high school for playing games.</p>

          <p>Switched to chemistry when I started college.</p>

          <p>
            Put everything into working on <Link to="/inlet">inlet</Link> about
            half way through.
          </p>

          <p>
            Made websites and mobile apps for a couple of startups for a little
            over a year after graduating.
          </p>

          <p>
            Along the way I picked up basic skills in:
            <ul>
              <li>Node</li>
              <li>Python</li>
              <li>Go</li>
              <li>SQL + NoSQL</li>
              <li>GraphQL</li>
              <li>React + React-Native</li>
              <li>Meteor</li>
              <li>
                Famo.us <i>(RIP)</i>
              </li>
              <li>TensorFlow</li>
            </ul>
          </p>

          <div className="link-container">
            <a href="https://github.com/jordangarside" target="_blank">
              <GithubIcon className="fa fa-github" />
            </a>
            <a href="https://angel.co/jordan-garside" target="_blank">
              <AngellistIcon className="fa fa-angellist" />
            </a>
            <a href="https://www.linkedin.com/in/jordangarside" target="_blank">
              <LinkedinIcon className="fa fa-linkedin" />
            </a>
            <a
              href="https://stackoverflow.com/users/2898510/jordan"
              target="_blank"
            >
              <StackOverflowIcon className="fa fa-stack-overflow" />
            </a>
            <a href="mailto:jordangarside@gmail.com" target="_blank">
              <EnvelopeIcon className="fa fa-envelope-o" />
            </a>
          </div>
        </div>
      </div>
    );
  }
}

export { About };
export default About;
