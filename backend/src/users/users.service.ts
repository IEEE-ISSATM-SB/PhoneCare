import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { User } from './user.schema';

import { UpdateProfileDto } from './dto/update-profile.dto';
import { UploadProfilePictureDto } from './dto/upload-profile-picture.dto';

import * as bcrypt from 'bcrypt';

import { RequestResetDto } from '../auth/dto/request-reset.dto';
import { ResetPasswordDto } from '../auth/dto/reset-password.dto';

@Injectable()
export class UsersService {
	constructor(@InjectModel(User.name) private userModel: Model<User>) {}

	async createUser(email: string, password: string, name?: string): Promise<User> {
		const user = new this.userModel({ email, password, name });
		return user.save();
	}

	async findByEmail(email: string): Promise<User | null> {
		return this.userModel.findOne({ email }).exec();
	}

	async generateOtp(email: string): Promise<string | null> {
		const user = await this.userModel.findOne({ email }).exec();
		if (!user) return null;
		// Generate 6-digit OTP
		const otp = Math.floor(100000 + Math.random() * 900000).toString();
		const expires = new Date(Date.now() + 10 * 60 * 1000); // 10 min expiry
		user.otpCode = otp;
		user.otpExpires = expires;
		await user.save();
		return otp;
	}

	async verifyOtpAndResetPassword(dto: ResetPasswordDto): Promise<boolean> {
		const user = await this.userModel.findOne({ email: dto.email }).exec();
		if (!user || !user.otpCode || !user.otpExpires) return false;
		if (user.otpCode !== dto.otp) return false;
		if (user.otpExpires < new Date()) return false;
		user.password = await bcrypt.hash(dto.newPassword, 10);
		user.otpCode = undefined;
		user.otpExpires = undefined;
		user.lastPasswordChange = new Date();
		await user.save();
		return true;
	}

		async updateProfile(userId: string, updateProfileDto: UpdateProfileDto): Promise<User | null> {
			const user = await this.userModel.findById(userId).exec();
			if (!user) return null;

			// Handle password change restriction
			if (updateProfileDto.password) {
				const now = new Date();
				if (user.lastPasswordChange) {
					const lastChange = new Date(user.lastPasswordChange);
					const diffDays = (now.getTime() - lastChange.getTime()) / (1000 * 60 * 60 * 24);
					if (diffDays < 7) {
						throw new Error('Password can only be changed once per week');
					}
				}
				updateProfileDto.password = await bcrypt.hash(updateProfileDto.password, 10);
				(updateProfileDto as any).lastPasswordChange = now;
			}

			return this.userModel.findByIdAndUpdate(userId, updateProfileDto, { new: true }).exec();
		}

	async uploadProfilePicture(userId: string, uploadProfilePictureDto: UploadProfilePictureDto): Promise<User | null> {
		return this.userModel.findByIdAndUpdate(userId, { profilePicture: uploadProfilePictureDto.profilePicture }, { new: true }).exec();
	}
}
