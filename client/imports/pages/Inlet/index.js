import React from "react";

class Inlet extends React.Component {
  componentWillMount() {
    document.title = "inlet | jordan garside";
  }
  render() {
    return (
      <div className="inlet-container template-container">
        <div className="inner-container">
          <h1>
            <a>inlet</a>
          </h1>

          <p>
            a platform for helping people understand why they believe in their
            beliefs
          </p>

          <p>
            This was my first project and I really overshot the features.
          </p>

          <p>
            A desktop version of inlet was finished, but it broke and I haven't
            had the time to fix it yet (since I'll start over from scratch).
          </p>

          <p>This is one of the top project on my list when I get the time.</p>
        </div>
      </div>
    );
  }
}

export { Inlet };
export default Inlet;
