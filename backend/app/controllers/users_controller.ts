import type { HttpContext } from "@adonisjs/core/http";

export default class UsersController {
	async index({ auth }: HttpContext) {
		if (auth.user) {
			return auth.user;
		}
	}
}
