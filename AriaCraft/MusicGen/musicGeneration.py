from audiocraft.models import MusicGen
from audiocraft.models import MultiBandDiffusion
import math
import torchaudio
import torch
import soundfile as sf
import time

USE_DIFFUSION_DECODER = False
# Using small model, better results would be obtained with `medium` or `large`.
model = MusicGen.get_pretrained('facebook/musicgen-small')
if USE_DIFFUSION_DECODER:
    mbd = MultiBandDiffusion.get_mbd_musicgen()

model.set_generation_params(use_sampling=True, top_k=250, duration=30)

class MusicGenaration :

    USE_DIFFUSION_DECODER = False
    audioCarftModel = MusicGen.get_pretrained('facebook/musicgen-small')
    if USE_DIFFUSION_DECODER:
        mbd = MultiBandDiffusion.get_mbd_musicgen()
    audioCarftModel.set_generation_params(
        use_sampling=True,
        top_k=250,
        duration=30
    )
    
    # def __init__(self) :
        # USE_DIFFUSION_DECODER = False
        # audioCarftModel = MusicGen.get_pretrained('facebook/musicgen-small')
        # if USE_DIFFUSION_DECODER:
        #     mbd = MultiBandDiffusion.get_mbd_musicgen()
        # audioCarftModel.set_generation_params(
        #     use_sampling=True,
        #     top_k=250,
        #     duration=30
        # )
        # self.audioCarftModel = audioCarftModel
        # try:
        #     res = model.generate_continuation(
        #         self._get_bip_bip(0.125).expand(2, -1, -1), 
        #         32000, ['Beautiful jazz that to be enjoyed under a tree in rain', 
        #                 'Heartful EDM with beautiful synths and chords'], 
        #         progress=True)
        #     res = torch.tensor(res)
        #     for out_res in res:
        #         torchaudio.save("output.mp3", out_res.to(device="cpu"), 32000)
        #     # self.model = model
        # except:
        #     raise Exception("Model failed successfully ;(")

    def _get_bip_bip(self, bip_duration=0.125, frequency=440,
                    duration=0.5, sample_rate=32000, device="cuda"):
        """Generates a series of bip bip at the given frequency."""
        t = torch.arange(
            int(duration * sample_rate), device="cuda", dtype=torch.float) / sample_rate
        wav = torch.cos(2 * math.pi * 440 * t)[None]
        tp = (t % (2 * bip_duration)) / (2 * bip_duration)
        envelope = (tp >= 0.5).float()
        return wav * envelope

    def _save_audio(self, samples, sample_rate, output_file_path):
        """Save audio samples to a file.

        Args:
            samples (torch.Tensor): a Tensor of decoded audio samples with shapes [B, C, T] or [C, T]
            sample_rate (int): sample rate audio should be saved with.
            output_file_path (str): path to save the audio file.
        """
        # Ensure the samples tensor is on CPU and detached
        samples = samples.detach().cpu().numpy()

        # Reshape if needed
        if samples.ndim == 2:
            samples = samples[0]

        # Save the audio file
        sf.write(output_file_path, samples, sample_rate)

    def _display_audio_and_save(self, samples: torch.Tensor, sample_rate: int, output_file_path = 'output.mp3'):
        """Display an audio player for the given audio samples and save the audio to a file.

        Args:
            samples (torch.Tensor): a Tensor of decoded audio samples with shapes [B, C, T] or [C, T]
            sample_rate (int): sample rate audio should be displayed and saved with.
            output_file_path (str): path to save the audio file.
        """
        # Ensure the samples tensor is on CPU and detached
        samples = samples.detach().cpu()

        # Check if samples is 3D tensor and flatten if necessary
        if samples.dim() == 3:
            samples = samples.squeeze(0)

        # Save the audio file
        self._save_audio(samples, sample_rate, output_file_path)

        # Optionally display the audio player (comment this out if you don't want to display it)
        # display(Audio(data=samples, rate=sample_rate))

    def generate_continuation(self, input_list, output_file_path='output.mp3'):
        res = self.audioCarftModel.generate_continuation(self._get_bip_bip(0.125).expand(2, -1, -1), 32000, input_list, progress = True)
        output_file_path_list = []
        for i,out_file in enumerate(res):
            timestr = time.strftime("%Y%m%d-%H%M%S")
            out_file_path = f'TestMusic_Generated_{output_file_path.split(sep=".")[0]}_{timestr}.mp3'
            output_file_path_list.append(out_file_path)
            torchaudio.save(out_file_path, out_file.to(device='cpu'), 32000, format='mp3')
        return output_file_path_list