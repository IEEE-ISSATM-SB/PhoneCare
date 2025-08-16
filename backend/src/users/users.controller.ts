import { Controller, Put, Body, Param, UseGuards, Req } from '@nestjs/common';
import { UsersService } from './users.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { UploadProfilePictureDto } from './dto/upload-profile-picture.dto';

@Controller('users')
export class UsersController {
	constructor(private readonly usersService: UsersService) {}

	// Example: userId from request param, in real app use JWT auth to get userId
	@Put(':id/profile')
	async updateProfile(@Param('id') userId: string, @Body() updateProfileDto: UpdateProfileDto) {
		return this.usersService.updateProfile(userId, updateProfileDto);
	}

	@Put(':id/profile-picture')
	async uploadProfilePicture(@Param('id') userId: string, @Body() uploadProfilePictureDto: UploadProfilePictureDto) {
		return this.usersService.uploadProfilePicture(userId, uploadProfilePictureDto);
	}
}
