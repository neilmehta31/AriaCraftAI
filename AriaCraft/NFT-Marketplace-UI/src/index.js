import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import { BrowserRouter } from "react-router-dom";
import { MetaMaskProvider } from "@metamask/sdk-react";

ReactDOM.render(

  <MetaMaskProvider
  debug={true}
  sdkOptions={{
    dappMetadata: {
      name: "AriaCraft NFT Marketplace",
      url: window.location.href,
    },
    infuraAPIKey: process.env.INFURA_API_KEY,
  }}
  >
  <BrowserRouter>
    <App />
  </BrowserRouter>
  </MetaMaskProvider>,
  document.getElementById('root')
);

