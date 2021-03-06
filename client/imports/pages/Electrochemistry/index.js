import React from "react";

class Electrochemistry extends React.Component {
  componentWillMount() {
    document.title = "electrochemistry | jordan garside";
  }
  render() {
    return (
      <div className="electrochem-container template-container">
        <div className="inner-container">
          <h1>Quantum Tunneling through Carbon Monolayers</h1>

          <p>
            Worked for about a year in a research lab with{" "}
            <a href="http://slowinskilabatcsulb.weebly.com/" target="_blank">
              Kris
            </a>.
          </p>

          <p>
            In that time I learned a bit about the frustrations of not having an
            adequate machine shop, as well as some basic electrochemical
            junction techniques.
          </p>

          <p>
            Published a{" "}
            <a
              href="http://www.electrochemsci.org/papers/vol9/90804345.pdf"
              target="_blank"
            >
              paper
            </a>{" "}
            on how the thickness of the water layer between carboxyl-terminated
            alkonthiols and the mercury electrode varies with the pH of the
            solution.
          </p>

          <p>
            Also worked with gallium-indium eutectic showing that the
            oxidized layer that forms on its surface has a measurable resistance
            that will be within the error for these junction experiments
            depending on the particular setup. We had quite a bit of data on
            this, but due to the circumstances never ended up publishing it.
          </p>
        </div>
      </div>
    );
  }
}

export { Electrochemistry };
export default Electrochemistry;
