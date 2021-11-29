import React, {Component} from 'react';
import './App.css';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import Paper from 'material-ui/Paper';

const style = {
    marginLeft: 12,
};

class App extends Component {

    redirectToHadoop(){
        window.location.href = 'http://34.135.237.146:30963/';
    }
    redirectToJupyterNotebook(){
        window.location.href = 'http://34.135.237.146:31749/';
    }
    redirectToSonarqube(){
        window.location.href = 'http://34.135.237.146:30070/';
    }
    redirectToSpark(){
        window.location.href = 'http://34.135.237.146:30299/';
    }

    render() {
        return (
            <MuiThemeProvider>
                <div className="centerize">
                    <Paper zDepth={1} className="content">
                        <h2>Big Data Processing Toolbox</h2>
                        <button className="button" onClick={()=>this.redirectToHadoop()}>Hadoop</button>
                        <button className="button" onClick={()=>this.redirectToJupyterNotebook()}>Jupyter notebook</button>
                        <button className="button" onClick={()=>this.redirectToSonarqube()}>Sonarqube</button>
                        <button className="button" onClick={()=>this.redirectToSpark()}>Apache Spark</button>
                    </Paper>
                </div>
            </MuiThemeProvider>
        );
    }

}

export default App;