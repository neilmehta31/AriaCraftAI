"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const hardhat_1 = require("hardhat");
function main() {
    return __awaiter(this, void 0, void 0, function* () {
        const arg1 = "MusicalNFT";
        const arg2 = "msclNFT";
        const MyContract = yield hardhat_1.ethers.getContractFactory("MusicalNFT");
        const myContract = yield MyContract.deploy(arg1, arg2);
        yield myContract.waitForDeployment();
        console.log(`VLX Token deployed to ${myContract.getAddress}`);
    });
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
//# sourceMappingURL=deployMusicalNFT.js.map