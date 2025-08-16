import { IsString } from 'class-validator';

export class UploadProfilePictureDto {
  @IsString()
  profilePicture: string; // This can be a URL or base64 string
}
