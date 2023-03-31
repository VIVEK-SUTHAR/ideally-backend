import { ethers } from "hardhat";
import { v4 as uuidv4 } from "uuid";

const printLine = () => {
  console.log("=============================================");
};

async function addIdea() {
  const [idea1, idea2, idea3] = await ethers.getSigners();
  const Ideally_Store = await ethers.getContractFactory("Ideally");
  const Ideally_Contract = await Ideally_Store.deploy();
  await Ideally_Contract.deployed();
  console.log(`Ideally deployed to ${Ideally_Contract.address} `);
  printLine();
  console.log("No Ideas Added");
  await getAllIdeas(Ideally_Contract);
  console.log("Adding ideas");
  await Ideally_Contract.connect(idea1).addIdea(
    "Build LensPlay",
    ["BlockChain", "SocialMedia"],
    "ipfs://Qmlhvdcewhjgcftwvcbjcxfgcwhuchftfdhoyctf"
  );
  await Ideally_Contract.connect(idea2).addIdea(
    "Build NeroCare",
    ["HealthCare"],
    "ar://jluyfbhaiugdufcwebivwetcvwecnwoguegowhcuywf"
  );
  await Ideally_Contract.connect(idea3).addIdea(
    "Deploy Patient Care on chain",
    ["HealthCare", "Medical"],
    "https://amazonaws.s3.store/us2-east/hasfdvjgvuufjcbj"
  );

  await Ideally_Contract.proposeCollabRequest(1, 0);
  const data = await Ideally_Contract.getPendingCollabReqests(1);
  for (const req of data) {
    console.log(req);
  }
  await Ideally_Contract.approveCollabrationRequest(1, 0);
  const udata = await Ideally_Contract.getPendingCollabReqests(1);
  for (const req of udata) {
    console.log(req);
  }
}

const addUpvote = async (contract, id) => {
  await contract.addUpvote(id);
};

const getAllIdeas = async (contractInstance) => {
  const allIdeas = await contractInstance.getAllIdeas();
  for (const idea of allIdeas) {
    console.log(
      "id",
      parseInt(idea.Id),
      "idea",
      idea.IdeaDescription,
      "Upvotes",
      parseInt(idea.TotalUpvotes),
      "Pitch URI",
      idea.pitchUri
    );
  }
};

addIdea().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
