import InvalidOAuthTokenException from "#exceptions/invalid_o_auth_token_exception";
import OAuthEmailUnverifiedException from "#exceptions/o_auth_email_unverified_exception";
import env from "#start/env";
import { OAuth2Client, type TokenPayload } from "google-auth-library";

export const providers = ["google"] as const;

type Provider = (typeof providers)[number];

export interface OAuthProviderPayload {
	email: string;
	name?: string;
	profilePictureUrl?: string;
}

export class OAuthService {
	private readonly googleClient = new OAuth2Client();

	public async verify(provider: Provider, idToken: string): Promise<OAuthProviderPayload> {
		switch (provider) {
			case "google":
				return await this.verifyGoogleToken(idToken);
			default:
				{
					// Ensures exhaustive check of providers
					const _exhaustiveCheck: never = provider;
				}
				throw new InvalidOAuthTokenException();
		}
	}

	private async verifyGoogleToken(idToken: string): Promise<OAuthProviderPayload> {
		let payload: TokenPayload;

		try {
			const ticket = await this.googleClient.verifyIdToken({
				idToken: idToken,
				audience: [env.get("GOOGLE_CLIENT_ID_WEB")],
			});

			const ticketPayload = ticket.getPayload();

			if (ticketPayload === undefined) {
				throw new InvalidOAuthTokenException();
			}

			payload = ticketPayload;

			if (
				payload.email === undefined ||
				payload.email_verified === false ||
				payload.email_verified === undefined
			) {
				throw new OAuthEmailUnverifiedException();
			}
		} catch {
			throw new InvalidOAuthTokenException();
		}

		let name: string | undefined;
		if (payload.name) name = payload.name;
		else if (payload.given_name && payload.family_name)
			name = `${payload.given_name} ${payload.family_name}`;

		const providerPayload = {
			email: payload.email,
			name,
			profilePictureUrl: payload.picture,
		} satisfies OAuthProviderPayload;

		return providerPayload;
	}
}
