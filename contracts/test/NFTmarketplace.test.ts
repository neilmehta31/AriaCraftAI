const { expect } = require("chai"); 
import { ethers } from "hardhat";

const toWei = (num) => ethers.parseEther(num.toString())
const fromWei = (num) => ethers.formatEther(num)

