import { MembershipService } from "../services/membership-service";
import type { UserNeuronsDTO, MembershipClaim } from "../../../../declarations/backend/backend.did";

function createMembershipStore() {
    async function getUserNeurons(): Promise<UserNeuronsDTO | undefined> {
        return new MembershipService().getUserNeurons();
    }

    async function claimMembership(): Promise<MembershipClaim | undefined> {
        return new MembershipService().claimMembership();
    }

    return {
        getUserNeurons,
        claimMembership,
    };
}

export const membershipStore = createMembershipStore();