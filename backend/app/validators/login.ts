import { providers } from "#services/oauth_service";
import vine from "@vinejs/vine";

const loginData = vine.group([
	vine.group.if((data) => "email" in data, {
		email: vine.string().email(),
		password: vine.string(),
	}),
	vine.group.if((data) => "provider" in data, {
		provider: vine.enum(providers),
		idToken: vine.string(),
	}),
]);

// The merge with an object is necessary for this to work properly.

export const loginValidator = vine.compile(vine.object({}).merge(loginData));
