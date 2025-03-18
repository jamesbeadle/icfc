export type NeuronSummary = {
  id: string;
  stakedAmount: string;
  lockPeriod: string;
  status: "active" | "dissolving";
  age: string;
  displayId: string;
};
