import React, { useState } from "react";
import "./navbar.css";
import { RiMenu3Line, RiCloseLine } from "react-icons/ri";
import logo from "../../assets/logo.png";
import { Link } from "react-router-dom";
import { useSDK } from "@metamask/sdk-react";

const Menu = () => (
  <>
    <Link to="/">
      <p>Explore</p>{" "}
    </Link>
    <p>My Items</p>
  </>
);

const Navbar = () => {
  const [toggleMenu, setToggleMenu] = useState(false);
  const [account, setAccount] = useState("");
  const [user, setUser] = useState(false);
  const { sdk, connected, connecting, provider, chainId } = useSDK();
  const [ethAcConnected, setIsVisible] = useState(true);

  const connect = async (event) => {
    try {
      const accounts = await sdk?.connect();
      setAccount(accounts?.[0]);
      toggleVisibility()
    } catch (err) {
      console.warn("failed to connect..", err);
    }
  };

  const toggleVisibility = () => {
    setIsVisible(!ethAcConnected);
  }

  const handleLogout = () => {
    setUser(false);
  };
  const handleLogin = () => {
    setUser(true);
  };


  return (
    <div className="navbar">
      <div className="navbar-links">
        <div className="navbar-links_logo">
          <img src={logo} className="logo-navbar" alt="logo" />
          <Link to="/">
            <h1>AriaCraft</h1>
          </Link>
        </div>
        <div className="navbar-links_container">
          <input type="text" placeholder="Search Item Here" autoFocus={true} />
          <Menu />
          {user && (
            <Link to="/">
              <p onClick={handleLogout}>Logout</p>
            </Link>
          )}
        </div>
      </div>
      <div className="navbar-sign">
        {user ? (
          <>
            <Link to="/create">
              <button type="button" className="primary-btn">
                Create
              </button>
            </Link>
            <button type="button" className="secondary-btn">
              Connect
            </button>
          </>
        ) : (
          <>
            <Link to="/login">
              <button
                type="button"
                className="primary-btn"
                onClick={handleLogin}
              >
                Sign In
              </button>
            </Link>
            <Link to="/register">
              <button type="button" className="secondary-btn">
                Sign Up
              </button>
            </Link>
             {connected && ethAcConnected && <button
                type="button"
                className="primary-btn"
                onClick={(event) => {connect(event.currentTarget);}}
              >
                Connect Metamask
              </button>}
              {connected && (
        <div>
          <>
            {account && `Connected account: ${account}`}
          </>
        </div>
      )}
          </>
        )}
      </div>
      <div className="navbar-menu">
        {toggleMenu ? (
          <RiCloseLine
            color="#fff"
            size={27}
            onClick={() => setToggleMenu(false)}
          />
        ) : (
          <RiMenu3Line
            color="#fff"
            size={27}
            onClick={() => setToggleMenu(true)}
          />
        )}
        {toggleMenu && (
          <div className="navbar-menu_container scale-up-center">
            <div className="navbar-menu_container-links">
              <Menu />
            </div>
            <div className="navbar-menu_container-links-sign">
              {user ? (
                <>
                  <Link to="/create">
                    <button type="button" className="primary-btn">
                      Create
                    </button>
                  </Link>
                  <button type="button" className="secondary-btn">
                    Connect
                  </button>
                </>
              ) : (
                <>
                  <Link to="/login">
                    <button
                      type="button"
                      className="primary-btn"
                      onClick={handleLogin}
                    >
                      Sign In
                    </button>
                  </Link>
                  <Link to="/register">
                    <button type="button" className="secondary-btn">
                      Sign Up
                    </button>
                  </Link>
                </>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Navbar;
