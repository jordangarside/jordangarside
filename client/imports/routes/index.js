import React from 'react';
import { Switch, Route } from 'react-router-dom';

import AboutPage from '/client/imports/pages/About';
// import CloudsziPage from '/client/imports/pages/Cloudszi';
import ElectrochemistryPage from '/client/imports/pages/Electrochemistry';
import HomePage from '/client/imports/pages/Home';
import InletPage from '/client/imports/pages/Inlet';
import TheoreticalChemistryPage from '/client/imports/pages/TheoreticalChemistry';

const Routes = () => (
  <Switch>
    <Route path="/" exact component={HomePage} />
    <Route path="/about-me" component={AboutPage} />
    {/* <Route path="/cloudszi" component={CloudsziPage} /> */}
    <Route path="/electrochemistry" component={ElectrochemistryPage} />
    <Route path="/inlet" component={InletPage} />
    <Route path="/theoretical-chemistry" component={TheoreticalChemistryPage} />
    <Route render={() => <h1>Page not found</h1>} />
  </Switch>
);

export default Routes;
