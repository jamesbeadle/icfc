export type NeuronSummary = {
  id: string;
  stakedAmount: string;
  lockPeriod: string;
  status: "locked" | "dissolving";
  age: string;
  displayId: string;
};
