import React from "react";

class TheoreticalChemistry extends React.Component {
  componentWillMount() {
    document.title = "theoretical chemistry | jordan garside";
  }
  render() {
    return (
      <div className="computational-chemistry-container template-container">
        <div className="inner-container">
          <h1>Machine Learning and Theoretical Chemistry</h1>

          <p>
            Started working on theoretical chemistry with{" "}
            <a
              href="https://www.linkedin.com/in/tapavicza-enrico-9b7b7659"
              target="_blank"
            >
              Enrico
            </a>{" "}
            at Long Beach State, while driving for Uber and Lyft.
          </p>

          <p>
            Concept based around combining cheap DFT caluclations with machine
            learning methods to get close to coupled cluster accuracy. The idea
            is you could do 20 coupled cluster calculations and generalize the
            error relative to DFT so that you could say run 1000 DFT
            calculations, add the error and get close to coupled cluster
            accuracy.
          </p>

          <p>
            Attempted to use neural networks, support vector machines, and quite
            a few ensemble methods. In the end Gradient Boosted Regression Trees
            worked best for this type of simple regression data.
          </p>

          <p>
            Started a Master's Program at University of Waterloo with{" "}
            <a
              href="http://scienide2.uwaterloo.ca/~nooijen/website_new_20_10_2011/home.html"
              target="_blank"
            >
              Marcel
            </a>.
          </p>

          <p>
            Worked on some 2-electron integral range separation stuff for
            periodic boundary condition calculations. Left after my second term to work on <a href="https://about.cloudszi.com">cloudszi</a>.
          </p>
        </div>
      </div>
    );
  }
}

export { TheoreticalChemistry };
export default TheoreticalChemistry;
