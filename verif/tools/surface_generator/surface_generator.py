#!/usr/bin/env python

from memory_surface import MemorySurfaceWeight, MemorySurfaceFeatureMap, MemorySurfaceFactory
import argparse
import time

def generate_feature_surface(args):
    msf = MemorySurfaceFactory.creat('FeatureMap')(args.file_name)
    #width, height, channel, component, batch, atomic_m, line_stride, surface_stride, batch_stride, data_type, pattern, file_name = config
    print (args)
    msf.generate_memory_surface(
        args.seed, args.width, args.height, args.channel, args.component, args.batch, args.atomic_memory, args.line_stride, args.surface_stride, args.batch_stride, args.data_type, args.pattern, args.file_name
    )
    msf.print_info()
    msf.dump_memory_surface_to_file()

def generate_weight_surface(args):
    msf = MemorySurfaceFactory.creat('Weight')(args.file_name)
    #width, height, channel, kernel_number, atomic_channel, kernel_per_group, data_type, alignment_in_byte, pattern, is_compressed, file_name = config
    print (args)
    msf.generate_memory_surface(
        args.seed, args.width, args.height, args.channel, args.kernel, args.atomic_channel, args.atomic_kernel, args.data_type, args.alignment_in_byte, args.pattern, args.is_compressed, args.file_name
    )
    msf.print_info()
    msf.dump_memory_surface_to_file()

def generate_image_pitch_surface(args):
    msf = MemorySurfaceFactory.creat('ImagePitch')(args.file_name)
    print (args)
    msf.generate_memory_surface(
        args.seed, args.width, args.height, args.channel, args.atomic_memory, args.line_stride, args.offset_x, args.pixel_format_name, args.data_type, args.pattern, args.file_name
    )
    msf.print_info()
    msf.dump_memory_surface_to_file()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Surface generator argument parser')
    #parser.add_argument('--format', choices=['feature','weight','image','auxiliary'],
    #                    required = True,
    #                    help='specify memory surface format',
    #                    )
    subparsers = parser.add_subparsers()
    ## Feature map surface
    parser_feature = subparsers.add_parser('feature')
    parser_feature.add_argument('--seed','-s',type=int,default=round(time.time()),
            required = True,
            help='Specify random seed'
            )
    parser_feature.add_argument('--width','-w',type=int,default=1,
            required = True,
            help='Specify width'
            )
    parser_feature.add_argument('--height','-hg',type=int,default=1,
            required = True,
            help='Specify height'
            )
    parser_feature.add_argument('--channel','-c',type=int,default=1,
            required = True,
            help='Specify channel'
            )
    parser_feature.add_argument('--batch','-b',type=int,default=1,
            required = False,
            help='Specify batch number'
            )
    parser_feature.add_argument('--component','-p',type=int,default=1,
            required = False,
            help='Specify component number'
            )
    parser_feature.add_argument('--atomic_memory','-am',type=int,default=1,
            required = True,
            help='Specify atomic memory'
            )
    parser_feature.add_argument('--line_stride','-ls',type=int,default=1,
            required = True,
            help='Specify line stride'
            )
    parser_feature.add_argument('--surface_stride','-ss',type=int,default=1,
            required = True,
            help='Specify surface stride'
            )
    parser_feature.add_argument('--batch_stride','-bs',type=int,default=1,
            required = False,
            help='Specify batch stride'
            )
    parser_feature.add_argument('--data_type','-dt',type=str,default='int8',
            choices=['int8','int16','float16'],
            required = True,
            help='Specify data type'
            )
    parser_feature.add_argument('--pattern','-pt',type=str,default='random',
            #choices=['nchw_index','nch_wxatom_index','random','ones','zeros'],
            required = True,
            help='Specify data pattern'
            )
    parser_feature.add_argument('--file_name','-fn',type=str,
            required = True,
            help='Specify file name'
            )
    parser_feature.set_defaults(func=generate_feature_surface)

    ## Weight surface
    parser_weight = subparsers.add_parser('weight')
    parser_weight.add_argument('--seed','-s',type=int,default=round(time.time()),
            required = True,
            help='Specify random seed'
            )
    parser_weight.add_argument('--width','-w',type=int,default=1,
            required = True,
            help='Specify width'
            )
    parser_weight.add_argument('--height','-hg',type=int,default=1,
            required = True,
            help='Specify height'
            )
    parser_weight.add_argument('--channel','-c',type=int,default=1,
            required = True,
            help='Specify channel'
            )
    parser_weight.add_argument('--kernel','-k',type=int,default=1,
            required = False,
            help='Specify kernel number'
            )
    parser_weight.add_argument('--atomic_channel','-ac',type=int,default=1,
            required = True,
            help='Specify atomic channel'
            )
    parser_weight.add_argument('--atomic_kernel','-kpg',type=int,default=1,
            required = True,
            help='Specify atomic kernel, also named kernel per group'
            )
    parser_weight.add_argument('--data_type','-dt',type=str,default='int8',
            choices=['int8','int16','float16'],
            required = True,
            help='Specify data type'
            )
    parser_weight.add_argument('--alignment_in_byte','-ab',type=int,default=1,
            required = False,
            help='Specify alignment in byte'
            )
    parser_weight.add_argument('--pattern','-pt',type=str,default='random',
            #choices=['nchw_index','nch_wxatom_index','random','ones','zeros'],
            required = True,
            help='Specify data pattern'
            )
    parser_weight.add_argument('--is_compressed','-ic',type=lambda s: s.lower() in ['true'],default=False,
            required = False,
            help='Specify is compressed weight'
            )
    parser_weight.add_argument('--file_name','-fn',type=str,
            required = True,
            help='Specify file name'
            )
    parser_weight.set_defaults(func=generate_weight_surface)

    ## image pitch surface
    parser_image_pitch = subparsers.add_parser('image_pitch')
    parser_image_pitch.add_argument('--seed','-s',type=int,default=round(time.time()),
            required = True,
            help='Specify random seed'
            )
    parser_image_pitch.add_argument('--width','-w',type=int,default=1,
            required = True,
            help='Specify width'
            )
    parser_image_pitch.add_argument('--height','-hg',type=int,default=1,
            required = True,
            help='Specify height'
            )
    parser_image_pitch.add_argument('--channel','-c',type=int,default=1,
            required = True,
            help='Specify channel'
            )
    parser_image_pitch.add_argument('--line_stride','-ls',type=str,default='',
            required = True,
            help='Specify line stride'
            )
    parser_image_pitch.add_argument('--offset_x','-ox',type=int,default=0,
            required = True,
            help='Specify offset x'
            )
    parser_image_pitch.add_argument('--atomic_memory','-am',type=int,default=1,
            required = True,
            help='Specify atomic memory'
            )
    parser_image_pitch.add_argument('--pixel_format_name','-pfn',type=str,default='A8R8G8B8',
            required = True,
            help='Specify pixel format name'
            )
    parser_image_pitch.add_argument('--data_type','-dt',type=str,default='int8',
            choices=['int8','int16','float16'],
            required = True,
            help='Specify data type'
            )
    parser_image_pitch.add_argument('--alignment_in_byte','-ab',type=int,default=1,
            required = False,
            help='Specify alignment in byte'
            )
    parser_image_pitch.add_argument('--pattern','-pt',type=str,default='random',
            #choices=['nchw_index','nch_wxatom_index','random','ones','zeros'],
            required = True,
            help='Specify data pattern'
            )
    parser_image_pitch.add_argument('--file_name','-fn',type=str,
            required = True,
            help='Specify file name'
            )
    parser_image_pitch.set_defaults(func=generate_image_pitch_surface)

    args = parser.parse_args()
    print(args)
    args.func(args)
