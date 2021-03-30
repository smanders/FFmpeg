include(CheckCSourceCompiles)
include(CheckCXXSourceCompiles)
include(CheckIncludeFile)

function(enable)
  foreach(opt ${ARGN})
    set(${opt} ON PARENT_SCOPE)
  endforeach()
endfunction()

function(disable)
  foreach(opt ${ARGN})
    set(${opt} OFF PARENT_SCOPE)
  endforeach()
endfunction()

function(check_func)
  set(func ${ARGV0})
  check_c_source_compiles("
extern int ${func}();
int main(void){ ${func}(); }
"
  check_func_${func}_compiles
  )
  if(check_func_${func}_compiles)
    set(${func} ON PARENT_SCOPE)
  else()
    set(${func} OFF PARENT_SCOPE)
  endif()
endfunction()

function(check_func_headers)
  set(headers ${ARGV0})
  set(func ${ARGV1})
  foreach(hdr ${headers})
    set(inc "${inc}\n#include \"${hdr}\"")
  endforeach()
  check_c_source_compiles("
${inc}
#include <stdint.h>
long check_${func}(void) { return (long) ${func}; }
int main(void) { int ret = 0;
  ret |= ((intptr_t)check_${func}) & 0xFFFF;
return ret; }
"
  check_func_headers_${func}_compiles
  )
  if(check_func_headers_${func}_compiles)
    set(${func} ON PARENT_SCOPE)
  else()
    set(${func} OFF PARENT_SCOPE)
  endif()
endfunction()

function(check_mathfunc)
  set(func ${ARGV0})
  if(DEFINED ARGV1)
    set(narg ${ARGV1})
    set(args "f, g")
  else()
    set(narg 1)
    set(args "f")
  endif()
  check_c_source_compiles("
#include <math.h>
float foo(float f, float g) { return ${func}(${args}); }
int main(void){ foo; }
"
  check_mathfunc_${func}_compiles
  )
  if(check_mathfunc_${func}_compiles)
    set(${func} ON PARENT_SCOPE)
  else()
    set(${func} OFF PARENT_SCOPE)
  endif()
endfunction()

function(check_headers)
  set(header ${ARGV0})
  string(REPLACE "." "_" header_ ${header})
  string(REPLACE "/" "_" header_ ${header_})
  check_include_file(${header} check_headers_${header_})
  if(check_headers_${header_})
    set(${header_} ON PARENT_SCOPE)
  else()
    set(${header_} OFF PARENT_SCOPE)
  endif()
endfunction()

# CONFIG_LIST contains configurable options, while HAVE_LIST is for
# system-dependent things.
set(AVCODEC_COMPONENTS
  bsfs
  decoders
  encoders
  hwaccels
  parsers
  )
set(AVDEVICE_COMPONENTS
  indevs
  outdevs
  )
set(AVFILTER_COMPONENTS
  filters
  )
set(AVFORMAT_COMPONENTS
  demuxers
  muxers
  protocols
  )
set(COMPONENT_LIST
  ${AVCODEC_COMPONENTS}
  ${AVDEVICE_COMPONENTS}
  ${AVFILTER_COMPONENTS}
  ${AVFORMAT_COMPONENTS}
  )
set(EXAMPLE_LIST
  avio_list_dir_example
  avio_reading_example
  decode_audio_example
  decode_video_example
  demuxing_decoding_example
  encode_audio_example
  encode_video_example
  extract_mvs_example
  filter_audio_example
  filtering_audio_example
  filtering_video_example
  http_multiclient_example
  hw_decode_example
  metadata_example
  muxing_example
  qsvdec_example
  remuxing_example
  resampling_audio_example
  scaling_video_example
  transcode_aac_example
  transcoding_example
  vaapi_encode_example
  vaapi_transcode_example
  )
set(EXTERNAL_AUTODETECT_LIBRARY_LIST
  alsa
  appkit
  avfoundation
  bzlib
  coreimage
  iconv
  libxcb
  libxcb_shm
  libxcb_shape
  libxcb_xfixes
  lzma
  mediafoundation
  schannel
  sdl2
  securetransport
  sndio
  xlib
  zlib
  )
set(EXTERNAL_LIBRARY_GPL_LIST
  avisynth
  frei0r
  libcdio
  libdavs2
  librubberband
  libvidstab
  libx264
  libx265
  libxavs
  libxavs2
  libxvid
  )
set(EXTERNAL_LIBRARY_NONFREE_LIST
  decklink
  libfdk_aac
  openssl
  libtls
  )
set(EXTERNAL_LIBRARY_VERSION3_LIST
  gmp
  libaribb24
  liblensfun
  libopencore_amrnb
  libopencore_amrwb
  libvmaf
  libvo_amrwbenc
  mbedtls
  rkmpp
  )
set(EXTERNAL_LIBRARY_GPLV3_LIST
  libsmbclient
  )
set(EXTERNAL_LIBRARY_LIST
  ${EXTERNAL_LIBRARY_GPL_LIST}
  ${EXTERNAL_LIBRARY_NONFREE_LIST}
  ${EXTERNAL_LIBRARY_VERSION3_LIST}
  ${EXTERNAL_LIBRARY_GPLV3_LIST}
  chromaprint
  gcrypt
  gnutls
  jni
  ladspa
  libaom
  libass
  libbluray
  libbs2b
  libcaca
  libcelt
  libcodec2
  libdav1d
  libdc1394
  libdrm
  libflite
  libfontconfig
  libfreetype
  libfribidi
  libglslang
  libgme
  libgsm
  libiec61883
  libilbc
  libjack
  libklvanc
  libkvazaar
  libmodplug
  libmp3lame
  libmysofa
  libopencv
  libopenh264
  libopenjpeg
  libopenmpt
  libopus
  libpulse
  librabbitmq
  librav1e
  librsvg
  librtmp
  libshine
  libsmbclient
  libsnappy
  libsoxr
  libspeex
  libsrt
  libssh
  libtensorflow
  libtesseract
  libtheora
  libtwolame
  libv4l2
  libvorbis
  libvpx
  libwavpack
  libwebp
  libxml2
  libzimg
  libzmq
  libzvbi
  lv2
  mediacodec
  openal
  opengl
  pocketsphinx
  vapoursynth
  )
set(HWACCEL_AUTODETECT_LIBRARY_LIST
  amf
  audiotoolbox
  crystalhd
  cuda
  cuda_llvm
  cuvid
  d3d11va
  dxva2
  ffnvcodec
  nvdec
  nvenc
  vaapi
  vdpau
  videotoolbox
  v4l2_m2m
  xvmc
  )
# catchall list of things that require external libs to link
set(EXTRALIBS_LIST
  cpu_init
  cws2fws
  )
set(HWACCEL_LIBRARY_NONFREE_LIST
  cuda_nvcc
  cuda_sdk
  libnpp
  )
set(HWACCEL_LIBRARY_LIST
  ${HWACCEL_LIBRARY_NONFREE_LIST}
  libmfx
  mmal
  omx
  opencl
  vulkan
  )
set(DOCUMENT_LIST
  doc
  htmlpages
  manpages
  podpages
  txtpages
  )
set(FEATURE_LIST
  ftrapv
  gray
  hardcoded_tables
  omx_rpi
  runtime_cpudetect
  safe_bitstream_reader
  shared
  small
  static
  swscale_alpha
  )
# this list should be kept in linking order
set(LIBRARY_LIST
  avdevice
  avfilter
  swscale
  postproc
  avformat
  avcodec
  swresample
  avresample
  avutil
  )
set(LICENSE_LIST
  gpl
  nonfree
  version3
  )
set(PROGRAM_LIST
  ffplay
  ffprobe
  ffmpeg
  )
set(SUBSYSTEM_LIST
  dct
  dwt
  error_resilience
  faan
  fast_unaligned
  fft
  lsp
  lzo
  mdct
  pixelutils
  network
  rdft
  )
# COMPONENT_LIST needs to come last to ensure correct dependency checking
set(CONFIG_LIST
  ${DOCUMENT_LIST}
  ${EXAMPLE_LIST}
  ${EXTERNAL_LIBRARY_LIST}
  ${EXTERNAL_AUTODETECT_LIBRARY_LIST}
  ${HWACCEL_LIBRARY_LIST}
  ${HWACCEL_AUTODETECT_LIBRARY_LIST}
  ${FEATURE_LIST}
  ${LICENSE_LIST}
  ${LIBRARY_LIST}
  ${PROGRAM_LIST}
  ${SUBSYSTEM_LIST}
  autodetect
  fontconfig
  large_tests
  linux_perf
  memory_poisoning
  neon_clobber_test
  ossfuzz
  pic
  thumb
  valgrind_backtrace
  xmm_clobber_test
  ${COMPONENT_LIST}
  )
set(THREADS_LIST
  pthreads
  os2threads
  w32threads
  )
set(ATOMICS_LIST
  atomics_gcc
  atomics_suncc
  atomics_win32
  )
set(AUTODETECT_LIBS
  ${EXTERNAL_AUTODETECT_LIBRARY_LIST}
  ${HWACCEL_AUTODETECT_LIBRARY_LIST}
  ${THREADS_LIST}
  )
set(ARCH_LIST
  aarch64
  alpha
  arm
  avr32
  avr32_ap
  avr32_uc
  bfin
  ia64
  m68k
  mips
  mips64
  parisc
  ppc
  ppc64
  s390
  sh4
  sparc
  sparc64
  tilegx
  tilepro
  tomi
  x86
  x86_32
  x86_64
  )
set(ARCH_EXT_LIST_ARM
  armv5te
  armv6
  armv6t2
  armv8
  neon
  vfp
  vfpv3
  setend
  )
set(ARCH_EXT_LIST_MIPS
  mipsfpu
  mips32r2
  mips32r5
  mips64r2
  mips32r6
  mips64r6
  mipsdsp
  mipsdspr2
  msa
  msa2
  )
set(ARCH_EXT_LIST_LOONGSON
  loongson2
  loongson3
  mmi
  )
set(ARCH_EXT_LIST_X86_SIMD
  aesni
  amd3dnow
  amd3dnowext
  avx
  avx2
  avx512
  fma3
  fma4
  mmx
  mmxext
  sse
  sse2
  sse3
  sse4
  sse42
  ssse3
  xop
  )
set(ARCH_EXT_LIST_PPC
  altivec
  dcbzl
  ldbrx
  power8
  ppc4xx
  vsx
  )
set(ARCH_EXT_LIST_X86
  ${ARCH_EXT_LIST_X86_SIMD}
  cpunop
  i686
  )
set(ARCH_EXT_LIST
  ${ARCH_EXT_LIST_ARM}
  ${ARCH_EXT_LIST_PPC}
  ${ARCH_EXT_LIST_X86}
  ${ARCH_EXT_LIST_MIPS}
  ${ARCH_EXT_LIST_LOONGSON}
  )
set(ARCH_FEATURES
  aligned_stack
  fast_64bit
  fast_clz
  fast_cmov
  local_aligned
  simd_align_16
  simd_align_32
  simd_align_64
  )
set(BUILTIN_LIST
  atomic_cas_ptr
  machine_rw_barrier
  MemoryBarrier
  mm_empty
  rdtsc
  sem_timedwait
  sync_val_compare_and_swap
  )
set(HAVE_LIST_CMDLINE
  inline_asm
  symver
  yasm
  )
set(HAVE_LIST_PUB
  bigendian
  fast_unaligned
  )
set(HEADERS_LIST
  arpa_inet_h
  asm_types_h
  cdio_paranoia_h
  cdio_paranoia_paranoia_h
  cuda_h
  dispatch_dispatch_h
  dev_bktr_ioctl_bt848_h
  dev_bktr_ioctl_meteor_h
  dev_ic_bt8xx_h
  dev_video_bktr_ioctl_bt848_h
  dev_video_meteor_ioctl_meteor_h
  direct_h
  dirent_h
  dxgidebug_h
  dxva_h
  ES2_gl_h
  gsm_h
  io_h
  linux_perf_event_h
  machine_ioctl_bt848_h
  machine_ioctl_meteor_h
  malloc_h
  opencv2_core_core_c_h
  OpenGL_gl3_h
  poll_h
  sys_param_h
  sys_resource_h
  sys_select_h
  sys_soundcard_h
  sys_time_h
  sys_un_h
  sys_videoio_h
  termios_h
  udplite_h
  unistd_h
  valgrind_valgrind_h
  windows_h
  winsock2_h
  )
set(INTRINSICS_LIST
  intrinsics_neon
  )
set(COMPLEX_FUNCS
  cabs
  cexp
  )
set(MATH_FUNCS
  atanf
  atan2f
  cbrt
  cbrtf
  copysign
  cosf
  erf
  exp2
  exp2f
  expf
  hypot
  isfinite
  isinf
  isnan
  ldexpf
  llrint
  llrintf
  log2
  log2f
  log10f
  lrint
  lrintf
  powf
  rint
  round
  roundf
  sinf
  trunc
  truncf
  )
set(SYSTEM_FEATURES
  dos_paths
  libc_msvcrt
  MMAL_PARAMETER_VIDEO_MAX_NUM_CALLBACKS
  section_data_rel_ro
  threads
  uwp
  winrt
  )
set(SYSTEM_FUNCS
  access
  aligned_malloc
  arc4random
  clock_gettime
  closesocket
  CommandLineToArgvW
  fcntl
  getaddrinfo
  gethrtime
  getopt
  GetModuleHandle
  GetProcessAffinityMask
  GetProcessMemoryInfo
  GetProcessTimes
  getrusage
  GetStdHandle
  GetSystemTimeAsFileTime
  gettimeofday
  glob
  glXGetProcAddress
  gmtime_r
  inet_aton
  isatty
  kbhit
  localtime_r
  lstat
  lzo1x_999_compress
  mach_absolute_time
  MapViewOfFile
  memalign
  mkstemp
  mmap
  mprotect
  nanosleep
  PeekNamedPipe
  posix_memalign
  pthread_cancel
  sched_getaffinity
  SecItemImport
  SetConsoleTextAttribute
  SetConsoleCtrlHandler
  SetDllDirectory
  setmode
  setrlimit
  Sleep
  strerror_r
  sysconf
  sysctl
  usleep
  UTGetOSTypeFromString
  VirtualAlloc
  wglGetProcAddress
  )
set(SYSTEM_LIBRARIES
  bcrypt
  vaapi_drm
  vaapi_x11
  vdpau_x11
  )
set(TOOLCHAIN_FEATURES
  as_arch_directive
  as_dn_directive
  as_fpu_directive
  as_func
  as_object_arch
  asm_mod_q
  blocks_extension
  ebp_available
  ebx_available
  gnu_as
  gnu_windres
  ibm_asm
  inline_asm_direct_symbol_refs
  inline_asm_labels
  inline_asm_nonlocal_labels
  pragma_deprecated
  rsync_contimeout
  symver_asm_label
  symver_gnu_asm
  vfp_args
  xform_asm
  xmm_clobbers
  )
set(TYPES_LIST
  kCMVideoCodecType_HEVC
  kCVPixelFormatType_420YpCbCr10BiPlanarVideoRange
  kCVImageBufferTransferFunction_SMPTE_ST_2084_PQ
  kCVImageBufferTransferFunction_ITU_R_2100_HLG
  kCVImageBufferTransferFunction_Linear
  socklen_t
  struct_addrinfo
  struct_group_source_req
  struct_ip_mreq_source
  struct_ipv6_mreq
  struct_msghdr_msg_flags
  struct_pollfd
  struct_rusage_ru_maxrss
  struct_sctp_event_subscribe
  struct_sockaddr_in6
  struct_sockaddr_sa_len
  struct_sockaddr_storage
  struct_stat_st_mtim_tv_nsec
  struct_v4l2_frmivalenum_discrete
  )
list(TRANSFORM ARCH_EXT_LIST APPEND _external OUTPUT_VARIABLE ARCH_EXT_LIST_EXTERNAL)
list(TRANSFORM ARCH_EXT_LIST APPEND _inline OUTPUT_VARIABLE ARCH_EXT_LIST_INLINE)
set(HAVE_LIST
  ${ARCH_EXT_LIST}
  ${ARCH_EXT_LIST_EXTERNAL}
  ${ARCH_EXT_LIST_INLINE}
  ${ARCH_FEATURES}
  ${BUILTIN_LIST}
  ${COMPLEX_FUNCS}
  ${HAVE_LIST_CMDLINE}
  ${HAVE_LIST_PUB}
  ${HEADERS_LIST}
  ${INTRINSICS_LIST}
  ${MATH_FUNCS}
  ${SYSTEM_FEATURES}
  ${SYSTEM_FUNCS}
  ${SYSTEM_LIBRARIES}
  ${THREADS_LIST}
  ${TOOLCHAIN_FEATURES}
  ${TYPES_LIST}
  makeinfo
  makeinfo_html
  opencl_d3d11
  opencl_drm_arm
  opencl_drm_beignet
  opencl_dxva2
  opencl_vaapi_beignet
  opencl_vaapi_intel_media
  perl
  pod2man
  texi2html
  )
# options emitted with CONFIG_ prefix but not available on the command line
set(CONFIG_EXTRA
  aandcttables
  ac3dsp
  adts_header
  audio_frame_queue
  audiodsp
  blockdsp
  bswapdsp
  cabac
  cbs
  cbs_av1
  cbs_h264
  cbs_h265
  cbs_jpeg
  cbs_mpeg2
  cbs_vp9
  dirac_parse
  dnn
  dvprofile
  exif
  faandct
  faanidct
  fdctdsp
  flacdsp
  fmtconvert
  frame_thread_encoder
  g722dsp
  golomb
  gplv3
  h263dsp
  h264chroma
  h264dsp
  h264parse
  h264pred
  h264qpel
  hevcparse
  hpeldsp
  huffman
  huffyuvdsp
  huffyuvencdsp
  idctdsp
  iirfilter
  mdct15
  intrax8
  iso_media
  ividsp
  jpegtables
  lgplv3
  libx262
  llauddsp
  llviddsp
  llvidencdsp
  lpc
  lzf
  me_cmp
  mpeg_er
  mpegaudio
  mpegaudiodsp
  mpegaudioheader
  mpegvideo
  mpegvideoenc
  mss34dsp
  pixblockdsp
  qpeldsp
  qsv
  qsvdec
  qsvenc
  qsvvpp
  rangecoder
  riffdec
  riffenc
  rtpdec
  rtpenc_chain
  rv34dsp
  scene_sad
  sinewin
  snappy
  srtp
  startcode
  texturedsp
  texturedspenc
  tpeldsp
  vaapi_1
  vaapi_encode
  vc1dsp
  videodsp
  vp3dsp
  vp56dsp
  vp8dsp
  wma_freqs
  wmv2dsp
  )
set(CMDLINE_SELECT
  ${ARCH_EXT_LIST}
  ${CONFIG_LIST}
  ${HAVE_LIST_CMDLINE}
  ${THREADS_LIST}
  asm
  cross_compile
  debug
  extra_warnings
  logging
  lto
  optimizations
  rpath
  stripping
  )
set(PATHS_LIST
  bindir
  datadir
  docdir
  incdir
  libdir
  mandir
  pkgconfigdir
  prefix
  shlibdir
  install_name_dir
  )
set(CMDLINE_SET
  ${PATHS_LIST}
  ar
  arch
  as
  assert_level
  build_suffix
  cc
  objcc
  cpu
  cross_prefix
  custom_allocator
  cxx
  dep_cc
  doxygen
  env
  extra_version
  gas
  host_cc
  host_cflags
  host_extralibs
  host_ld
  host_ldflags
  host_os
  ignore_tests
  install
  ld
  ln_s
  logfile
  malloc_prefix
  nm
  optflags
  nvcc
  nvccflags
  pkg_config
  pkg_config_flags
  progs_suffix
  random_seed
  ranlib
  samples
  strip
  sws_max_filter_size
  sysinclude
  sysroot
  target_exec
  target_os
  target_path
  target_samples
  tempprefix
  toolchain
  valgrind
  windres
  x86asmexe
  )
set(CMDLINE_APPEND
  extra_cflags
  extra_cxxflags
  extra_objcflags
  host_cppflags
  )
# code dependency declarations
# architecture extensions
set(armv5te_deps arm)
set(armv6_deps arm)
set(armv6t2_deps arm)
set(armv8_deps aarch64)
set(neon_deps_any aarch64 arm)
set(intrinsics_neon_deps neon)
set(vfp_deps_any aarch64 arm)
set(vfpv3_deps vfp)
set(setend_deps arm)
#map 'eval ${v}_inline_deps=inline_asm' $ARCH_EXT_LIST_ARM
set(altivec_deps ppc)
set(dcbzl_deps ppc)
set(ldbrx_deps ppc)
set(ppc4xx_deps ppc)
set(vsx_deps altivec)
set(power8_deps vsx)
###
set(loongson2_deps mips)
set(loongson3_deps mips)
set(mips32r2_deps mips)
set(mips32r5_deps mips)
set(mips32r6_deps mips)
set(mips64r2_deps mips)
set(mips64r6_deps mips)
set(mipsfpu_deps mips)
set(mipsdsp_deps mips)
set(mipsdspr2_deps mips)
set(mmi_deps mips)
set(msa_deps mipsfpu)
set(msa2_deps msa)
###
set(cpunop_deps i686)
set(x86_64_select i686)
set(x86_64_suggest fast_cmov)
###
set(amd3dnow_deps mmx)
set(amd3dnowext_deps amd3dnow)
set(i686_deps x86)
set(mmx_deps x86)
set(mmxext_deps mmx)
set(sse_deps mmxext)
set(sse2_deps sse)
set(sse3_deps sse2)
set(ssse3_deps sse3)
set(sse4_deps ssse3)
set(sse42_deps sse4)
set(aesni_deps sse42)
set(avx_deps sse42)
set(xop_deps avx)
set(fma3_deps avx)
set(fma4_deps avx)
set(avx2_deps avx)
set(avx512_deps avx2)
###
set(mmx_external_deps x86asm)
set(mmx_inline_deps inline_asm x86)
set(mmx_suggest mmx_external mmx_inline)
###
#for ext in $(filter_out mmx $ARCH_EXT_LIST_X86_SIMD); do
#    eval dep=\$${ext}_deps
#    eval ${ext}_external_deps='"${dep}_external"'
#    eval ${ext}_inline_deps='"${dep}_inline"'
#    eval ${ext}_suggest='"${ext}_external ${ext}_inline"'
#done
###
set(aligned_stack_if_any aarch64 ppc x86)
set(fast_64bit_if_any aarch64 alpha ia64 mips64 parisc64 ppc64 sparc64 x86_64)
set(fast_clz_if_any aarch64 alpha avr32 mips ppc x86)
set(fast_unaligned_if_any aarch64 ppc x86)
set(simd_align_16_if_any altivec neon sse)
set(simd_align_32_if_any avx)
set(simd_align_64_if_any avx512)
# system capabilities
set(linux_perf_deps linux_perf_event_h)
set(symver_if_any symver_asm_label symver_gnu_asm)
set(valgrind_backtrace_conflict optimizations)
set(valgrind_backtrace_deps valgrind_valgrind_h)
# threading support
set(atomics_gcc_if sync_val_compare_and_swap)
set(atomics_suncc_if atomic_cas_ptr machine_rw_barrier)
set(atomics_win32_if MemoryBarrier)
set(atomics_native_if_any ${ATOMICS_LIST})
set(w32threads_deps atomics_native)
set(threads_if_any $THREADS_LIST)
# subsystems
set(cbs_av1_select cbs)
set(cbs_h264_select cbs)
set(cbs_h265_select cbs)
set(cbs_jpeg_select cbs)
set(cbs_mpeg2_select cbs)
set(cbs_vp9_select cbs)
set(dct_select rdft)
set(dirac_parse_select golomb)
set(dnn_suggest libtensorflow)
set(error_resilience_select me_cmp)
set(faandct_deps faan)
set(faandct_select fdctdsp)
set(faanidct_deps faan)
set(faanidct_select idctdsp)
set(h264dsp_select startcode)
set(hevcparse_select golomb)
set(frame_thread_encoder_deps encoders threads)
set(intrax8_select blockdsp idctdsp)
set(mdct_select fft)
set(mdct15_select fft)
set(me_cmp_select fdctdsp idctdsp pixblockdsp)
set(mpeg_er_select error_resilience)
set(mpegaudio_select mpegaudiodsp mpegaudioheader)
set(mpegaudiodsp_select dct)
set(mpegvideo_select blockdsp h264chroma hpeldsp idctdsp me_cmp mpeg_er videodsp)
set(mpegvideoenc_select aandcttables me_cmp mpegvideo pixblockdsp qpeldsp)
set(vc1dsp_select h264chroma qpeldsp startcode)
set(rdft_select fft)
# decoders / encoders
set(aac_decoder_select adts_header mdct15 mdct sinewin)
set(aac_fixed_decoder_select adts_header mdct sinewin)
set(aac_encoder_select audio_frame_queue iirfilter lpc mdct sinewin)
set(aac_latm_decoder_select aac_decoder aac_latm_parser)
set(ac3_decoder_select ac3_parser ac3dsp bswapdsp fmtconvert mdct)
set(ac3_fixed_decoder_select ac3_parser ac3dsp bswapdsp mdct)
set(ac3_encoder_select ac3dsp audiodsp mdct me_cmp)
set(ac3_fixed_encoder_select ac3dsp audiodsp mdct me_cmp)
set(acelp_kelvin_decoder_select audiodsp)
set(adpcm_g722_decoder_select g722dsp)
set(adpcm_g722_encoder_select g722dsp)
set(aic_decoder_select golomb idctdsp)
set(alac_encoder_select lpc)
set(als_decoder_select bswapdsp)
set(amrnb_decoder_select lsp)
set(amrwb_decoder_select lsp)
set(amv_decoder_select sp5x_decoder exif)
set(amv_encoder_select jpegtables mpegvideoenc)
set(ape_decoder_select bswapdsp llauddsp)
set(apng_decoder_deps zlib)
set(apng_encoder_deps zlib)
set(apng_encoder_select llvidencdsp)
set(aptx_decoder_select audio_frame_queue)
set(aptx_encoder_select audio_frame_queue)
set(aptx_hd_decoder_select audio_frame_queue)
set(aptx_hd_encoder_select audio_frame_queue)
set(asv1_decoder_select blockdsp bswapdsp idctdsp)
set(asv1_encoder_select aandcttables bswapdsp fdctdsp pixblockdsp)
set(asv2_decoder_select blockdsp bswapdsp idctdsp)
set(asv2_encoder_select aandcttables bswapdsp fdctdsp pixblockdsp)
set(atrac1_decoder_select mdct sinewin)
set(atrac3_decoder_select mdct)
set(atrac3al_decoder_select mdct)
set(atrac3p_decoder_select mdct sinewin)
set(atrac3pal_decoder_select mdct sinewin)
set(atrac9_decoder_select mdct)
set(avrn_decoder_select exif jpegtables)
set(bink_decoder_select blockdsp hpeldsp)
set(binkaudio_dct_decoder_select mdct rdft dct sinewin wma_freqs)
set(binkaudio_rdft_decoder_select mdct rdft sinewin wma_freqs)
set(cavs_decoder_select blockdsp golomb h264chroma idctdsp qpeldsp videodsp)
set(clearvideo_decoder_select idctdsp)
set(cllc_decoder_select bswapdsp)
set(comfortnoise_encoder_select lpc)
set(cook_decoder_select audiodsp mdct sinewin)
set(cscd_decoder_select lzo)
set(cscd_decoder_suggest zlib)
set(dca_decoder_select mdct)
set(dca_encoder_select mdct)
set(dds_decoder_select texturedsp)
set(dirac_decoder_select dirac_parse dwt golomb videodsp mpegvideoenc)
set(dnxhd_decoder_select blockdsp idctdsp)
set(dnxhd_encoder_select blockdsp fdctdsp idctdsp mpegvideoenc pixblockdsp)
set(dolby_e_decoder_select mdct)
set(dvvideo_decoder_select dvprofile idctdsp)
set(dvvideo_encoder_select dvprofile fdctdsp me_cmp pixblockdsp)
set(dxa_decoder_deps zlib)
set(dxv_decoder_select lzf texturedsp)
set(eac3_decoder_select ac3_decoder)
set(eac3_encoder_select ac3_encoder)
set(eamad_decoder_select aandcttables blockdsp bswapdsp idctdsp mpegvideo)
set(eatgq_decoder_select aandcttables)
set(eatqi_decoder_select aandcttables blockdsp bswapdsp idctdsp)
set(exr_decoder_deps zlib)
set(ffv1_decoder_select rangecoder)
set(ffv1_encoder_select rangecoder)
set(ffvhuff_decoder_select huffyuv_decoder)
set(ffvhuff_encoder_select huffyuv_encoder)
set(fic_decoder_select golomb)
set(flac_decoder_select flacdsp)
set(flac_encoder_select bswapdsp flacdsp lpc)
set(flashsv2_decoder_deps zlib)
set(flashsv2_encoder_deps zlib)
set(flashsv_decoder_deps zlib)
set(flashsv_encoder_deps zlib)
set(flv_decoder_select h263_decoder)
set(flv_encoder_select h263_encoder)
set(fourxm_decoder_select blockdsp bswapdsp)
set(fraps_decoder_select bswapdsp huffman)
set(g2m_decoder_deps zlib)
set(g2m_decoder_select blockdsp idctdsp jpegtables)
set(g729_decoder_select audiodsp)
set(h261_decoder_select mpegvideo)
set(h261_encoder_select mpegvideoenc)
set(h263_decoder_select h263_parser h263dsp mpegvideo qpeldsp)
set(h263_encoder_select h263dsp mpegvideoenc)
set(h263i_decoder_select h263_decoder)
set(h263p_decoder_select h263_decoder)
set(h263p_encoder_select h263_encoder)
set(h264_decoder_select cabac golomb h264chroma h264dsp h264parse h264pred h264qpel videodsp)
set(h264_decoder_suggest error_resilience)
set(hap_decoder_select snappy texturedsp)
set(hap_encoder_deps libsnappy)
set(hap_encoder_select texturedspenc)
set(hevc_decoder_select bswapdsp cabac golomb hevcparse videodsp)
set(huffyuv_decoder_select bswapdsp huffyuvdsp llviddsp)
set(huffyuv_encoder_select bswapdsp huffman huffyuvencdsp llvidencdsp)
set(hymt_decoder_select huffyuv_decoder)
set(iac_decoder_select imc_decoder)
set(imc_decoder_select bswapdsp fft mdct sinewin)
set(imm4_decoder_select bswapdsp)
set(imm5_decoder_select h264_decoder hevc_decoder)
set(indeo3_decoder_select hpeldsp)
set(indeo4_decoder_select ividsp)
set(indeo5_decoder_select ividsp)
set(interplay_video_decoder_select hpeldsp)
set(jpegls_decoder_select mjpeg_decoder)
set(jv_decoder_select blockdsp)
set(lagarith_decoder_select llviddsp)
set(ljpeg_encoder_select idctdsp jpegtables mpegvideoenc)
set(lscr_decoder_deps zlib)
set(magicyuv_decoder_select llviddsp)
set(magicyuv_encoder_select llvidencdsp)
set(mdec_decoder_select blockdsp bswapdsp idctdsp mpegvideo)
set(metasound_decoder_select lsp mdct sinewin)
set(mimic_decoder_select blockdsp bswapdsp hpeldsp idctdsp)
set(mjpeg_decoder_select blockdsp hpeldsp exif idctdsp jpegtables)
set(mjpeg_encoder_select jpegtables mpegvideoenc)
set(mjpegb_decoder_select mjpeg_decoder)
set(mlp_decoder_select mlp_parser)
set(mlp_encoder_select lpc audio_frame_queue)
set(motionpixels_decoder_select bswapdsp)
set(mp1_decoder_select mpegaudio)
set(mp1float_decoder_select mpegaudio)
set(mp2_decoder_select mpegaudio)
set(mp2float_decoder_select mpegaudio)
set(mp3_decoder_select mpegaudio)
set(mp3adu_decoder_select mpegaudio)
set(mp3adufloat_decoder_select mpegaudio)
set(mp3float_decoder_select mpegaudio)
set(mp3on4_decoder_select mpegaudio)
set(mp3on4float_decoder_select mpegaudio)
set(mpc7_decoder_select bswapdsp mpegaudiodsp)
set(mpc8_decoder_select mpegaudiodsp)
set(mpegvideo_decoder_select mpegvideo)
set(mpeg1video_decoder_select mpegvideo)
set(mpeg1video_encoder_select mpegvideoenc h263dsp)
set(mpeg2video_decoder_select mpegvideo)
set(mpeg2video_encoder_select mpegvideoenc h263dsp)
set(mpeg4_decoder_select h263_decoder mpeg4video_parser)
set(mpeg4_encoder_select h263_encoder)
set(msa1_decoder_select mss34dsp)
set(mscc_decoder_deps zlib)
set(msmpeg4v1_decoder_select h263_decoder)
set(msmpeg4v2_decoder_select h263_decoder)
set(msmpeg4v2_encoder_select h263_encoder)
set(msmpeg4v3_decoder_select h263_decoder)
set(msmpeg4v3_encoder_select h263_encoder)
set(mss2_decoder_select mpegvideo qpeldsp vc1_decoder)
set(mts2_decoder_select mss34dsp)
set(mv30_decoder_select aandcttables blockdsp)
set(mvha_decoder_deps zlib)
set(mvha_decoder_select llviddsp)
set(mwsc_decoder_deps zlib)
set(mxpeg_decoder_select mjpeg_decoder)
set(nellymoser_decoder_select mdct sinewin)
set(nellymoser_encoder_select audio_frame_queue mdct sinewin)
set(notchlc_decoder_select lzf)
set(nuv_decoder_select idctdsp lzo)
set(on2avc_decoder_select mdct)
set(opus_decoder_deps swresample)
set(opus_decoder_select mdct15)
set(opus_encoder_select audio_frame_queue mdct15)
set(png_decoder_deps zlib)
set(png_encoder_deps zlib)
set(png_encoder_select llvidencdsp)
set(prores_decoder_select blockdsp idctdsp)
set(prores_encoder_select fdctdsp)
set(qcelp_decoder_select lsp)
set(qdm2_decoder_select mdct rdft mpegaudiodsp)
set(ra_144_decoder_select audiodsp)
set(ra_144_encoder_select audio_frame_queue lpc audiodsp)
set(ralf_decoder_select golomb)
set(rasc_decoder_deps zlib)
set(rawvideo_decoder_select bswapdsp)
set(rscc_decoder_deps zlib)
set(rtjpeg_decoder_select me_cmp)
set(rv10_decoder_select h263_decoder)
set(rv10_encoder_select h263_encoder)
set(rv20_decoder_select h263_decoder)
set(rv20_encoder_select h263_encoder)
set(rv30_decoder_select golomb h264pred h264qpel mpegvideo rv34dsp)
set(rv40_decoder_select golomb h264pred h264qpel mpegvideo rv34dsp)
set(screenpresso_decoder_deps zlib)
set(shorten_decoder_select bswapdsp)
set(sipr_decoder_select lsp)
set(snow_decoder_select dwt h264qpel hpeldsp me_cmp rangecoder videodsp)
set(snow_encoder_select dwt h264qpel hpeldsp me_cmp mpegvideoenc rangecoder)
set(sonic_decoder_select golomb rangecoder)
set(sonic_encoder_select golomb rangecoder)
set(sonic_ls_encoder_select golomb rangecoder)
set(sp5x_decoder_select mjpeg_decoder)
set(speedhq_decoder_select mpegvideo)
set(srgc_decoder_deps zlib)
set(svq1_decoder_select hpeldsp)
set(svq1_encoder_select hpeldsp me_cmp mpegvideoenc)
set(svq3_decoder_select golomb h264dsp h264parse h264pred hpeldsp tpeldsp videodsp)
set(svq3_decoder_suggest zlib)
set(tak_decoder_select audiodsp)
set(tdsc_decoder_deps zlib)
set(tdsc_decoder_select mjpeg_decoder)
set(theora_decoder_select vp3_decoder)
set(thp_decoder_select mjpeg_decoder)
set(tiff_decoder_select mjpeg_decoder)
set(tiff_decoder_suggest zlib lzma)
set(tiff_encoder_suggest zlib)
set(truehd_decoder_select mlp_parser)
set(truehd_encoder_select lpc audio_frame_queue)
set(truemotion2_decoder_select bswapdsp)
set(truespeech_decoder_select bswapdsp)
set(tscc_decoder_deps zlib)
set(twinvq_decoder_select mdct lsp sinewin)
set(txd_decoder_select texturedsp)
set(utvideo_decoder_select bswapdsp llviddsp)
set(utvideo_encoder_select bswapdsp huffman llvidencdsp)
set(vble_decoder_select llviddsp)
set(vc1_decoder_select blockdsp h263_decoder h264qpel intrax8 mpegvideo vc1dsp)
set(vc1image_decoder_select vc1_decoder)
set(vorbis_decoder_select mdct)
set(vorbis_encoder_select audio_frame_queue mdct)
set(vp3_decoder_select hpeldsp vp3dsp videodsp)
set(vp4_decoder_select vp3_decoder)
set(vp5_decoder_select h264chroma hpeldsp videodsp vp3dsp vp56dsp)
set(vp6_decoder_select h264chroma hpeldsp huffman videodsp vp3dsp vp56dsp)
set(vp6a_decoder_select vp6_decoder)
set(vp6f_decoder_select vp6_decoder)
set(vp7_decoder_select h264pred videodsp vp8dsp)
set(vp8_decoder_select h264pred videodsp vp8dsp)
set(vp9_decoder_select videodsp vp9_parser vp9_superframe_split_bsf)
set(wcmv_decoder_deps zlib)
set(webp_decoder_select vp8_decoder exif)
set(wmalossless_decoder_select llauddsp)
set(wmapro_decoder_select mdct sinewin wma_freqs)
set(wmav1_decoder_select mdct sinewin wma_freqs)
set(wmav1_encoder_select mdct sinewin wma_freqs)
set(wmav2_decoder_select mdct sinewin wma_freqs)
set(wmav2_encoder_select mdct sinewin wma_freqs)
set(wmavoice_decoder_select lsp rdft dct mdct sinewin)
set(wmv1_decoder_select h263_decoder)
set(wmv1_encoder_select h263_encoder)
set(wmv2_decoder_select blockdsp error_resilience h263_decoder idctdsp intrax8 videodsp wmv2dsp)
set(wmv2_encoder_select h263_encoder wmv2dsp)
set(wmv3_decoder_select vc1_decoder)
set(wmv3image_decoder_select wmv3_decoder)
set(xma1_decoder_select wmapro_decoder)
set(xma2_decoder_select wmapro_decoder)
set(ylc_decoder_select bswapdsp)
set(zerocodec_decoder_deps zlib)
set(zlib_decoder_deps zlib)
set(zlib_encoder_deps zlib)
set(zmbv_decoder_deps zlib)
set(zmbv_encoder_deps zlib)
# hardware accelerators
set(crystalhd_deps libcrystalhd_libcrystalhd_if_h)
set(cuda_deps ffnvcodec)
set(cuvid_deps ffnvcodec)
set(d3d11va_deps dxva_h ID3D11VideoDecoder ID3D11VideoContext)
set(dxva2_deps dxva2api_h DXVA2_ConfigPictureDecode ole32 user32)
set(ffnvcodec_deps_any libdl LoadLibrary)
set(nvdec_deps ffnvcodec)
set(vaapi_x11_deps xlib)
set(videotoolbox_hwaccel_deps videotoolbox pthreads)
set(videotoolbox_hwaccel_extralibs -framework QuartzCore)
set(xvmc_deps X11_extensions_XvMClib_h)
###
set(h263_vaapi_hwaccel_deps vaapi)
set(h263_vaapi_hwaccel_select h263_decoder)
set(h263_videotoolbox_hwaccel_deps videotoolbox)
set(h263_videotoolbox_hwaccel_select h263_decoder)
set(h264_d3d11va_hwaccel_deps d3d11va)
set(h264_d3d11va_hwaccel_select h264_decoder)
set(h264_d3d11va2_hwaccel_deps d3d11va)
set(h264_d3d11va2_hwaccel_select h264_decoder)
set(h264_dxva2_hwaccel_deps dxva2)
set(h264_dxva2_hwaccel_select h264_decoder)
set(h264_nvdec_hwaccel_deps nvdec)
set(h264_nvdec_hwaccel_select h264_decoder)
set(h264_vaapi_hwaccel_deps vaapi)
set(h264_vaapi_hwaccel_select h264_decoder)
set(h264_vdpau_hwaccel_deps vdpau)
set(h264_vdpau_hwaccel_select h264_decoder)
set(h264_videotoolbox_hwaccel_deps videotoolbox)
set(h264_videotoolbox_hwaccel_select h264_decoder)
set(hevc_d3d11va_hwaccel_deps d3d11va DXVA_PicParams_HEVC)
set(hevc_d3d11va_hwaccel_select hevc_decoder)
set(hevc_d3d11va2_hwaccel_deps d3d11va DXVA_PicParams_HEVC)
set(hevc_d3d11va2_hwaccel_select hevc_decoder)
set(hevc_dxva2_hwaccel_deps dxva2 DXVA_PicParams_HEVC)
set(hevc_dxva2_hwaccel_select hevc_decoder)
set(hevc_nvdec_hwaccel_deps nvdec)
set(hevc_nvdec_hwaccel_select hevc_decoder)
set(hevc_vaapi_hwaccel_deps vaapi VAPictureParameterBufferHEVC)
set(hevc_vaapi_hwaccel_select hevc_decoder)
set(hevc_vdpau_hwaccel_deps vdpau VdpPictureInfoHEVC)
set(hevc_vdpau_hwaccel_select hevc_decoder)
set(hevc_videotoolbox_hwaccel_deps videotoolbox)
set(hevc_videotoolbox_hwaccel_select hevc_decoder)
set(mjpeg_nvdec_hwaccel_deps nvdec)
set(mjpeg_nvdec_hwaccel_select mjpeg_decoder)
set(mjpeg_vaapi_hwaccel_deps vaapi)
set(mjpeg_vaapi_hwaccel_select mjpeg_decoder)
set(mpeg_xvmc_hwaccel_deps xvmc)
set(mpeg_xvmc_hwaccel_select mpeg2video_decoder)
set(mpeg1_nvdec_hwaccel_deps nvdec)
set(mpeg1_nvdec_hwaccel_select mpeg1video_decoder)
set(mpeg1_vdpau_hwaccel_deps vdpau)
set(mpeg1_vdpau_hwaccel_select mpeg1video_decoder)
set(mpeg1_videotoolbox_hwaccel_deps videotoolbox)
set(mpeg1_videotoolbox_hwaccel_select mpeg1video_decoder)
set(mpeg1_xvmc_hwaccel_deps xvmc)
set(mpeg1_xvmc_hwaccel_select mpeg1video_decoder)
set(mpeg2_d3d11va_hwaccel_deps d3d11va)
set(mpeg2_d3d11va_hwaccel_select mpeg2video_decoder)
set(mpeg2_d3d11va2_hwaccel_deps d3d11va)
set(mpeg2_d3d11va2_hwaccel_select mpeg2video_decoder)
set(mpeg2_dxva2_hwaccel_deps dxva2)
set(mpeg2_dxva2_hwaccel_select mpeg2video_decoder)
set(mpeg2_nvdec_hwaccel_deps nvdec)
set(mpeg2_nvdec_hwaccel_select mpeg2video_decoder)
set(mpeg2_vaapi_hwaccel_deps vaapi)
set(mpeg2_vaapi_hwaccel_select mpeg2video_decoder)
set(mpeg2_vdpau_hwaccel_deps vdpau)
set(mpeg2_vdpau_hwaccel_select mpeg2video_decoder)
set(mpeg2_videotoolbox_hwaccel_deps videotoolbox)
set(mpeg2_videotoolbox_hwaccel_select mpeg2video_decoder)
set(mpeg2_xvmc_hwaccel_deps xvmc)
set(mpeg2_xvmc_hwaccel_select mpeg2video_decoder)
set(mpeg4_nvdec_hwaccel_deps nvdec)
set(mpeg4_nvdec_hwaccel_select mpeg4_decoder)
set(mpeg4_vaapi_hwaccel_deps vaapi)
set(mpeg4_vaapi_hwaccel_select mpeg4_decoder)
set(mpeg4_vdpau_hwaccel_deps vdpau)
set(mpeg4_vdpau_hwaccel_select mpeg4_decoder)
set(mpeg4_videotoolbox_hwaccel_deps videotoolbox)
set(mpeg4_videotoolbox_hwaccel_select mpeg4_decoder)
set(vc1_d3d11va_hwaccel_deps d3d11va)
set(vc1_d3d11va_hwaccel_select vc1_decoder)
set(vc1_d3d11va2_hwaccel_deps d3d11va)
set(vc1_d3d11va2_hwaccel_select vc1_decoder)
set(vc1_dxva2_hwaccel_deps dxva2)
set(vc1_dxva2_hwaccel_select vc1_decoder)
set(vc1_nvdec_hwaccel_deps nvdec)
set(vc1_nvdec_hwaccel_select vc1_decoder)
set(vc1_vaapi_hwaccel_deps vaapi)
set(vc1_vaapi_hwaccel_select vc1_decoder)
set(vc1_vdpau_hwaccel_deps vdpau)
set(vc1_vdpau_hwaccel_select vc1_decoder)
set(vp8_nvdec_hwaccel_deps nvdec)
set(vp8_nvdec_hwaccel_select vp8_decoder)
set(vp8_vaapi_hwaccel_deps vaapi)
set(vp8_vaapi_hwaccel_select vp8_decoder)
set(vp9_d3d11va_hwaccel_deps d3d11va DXVA_PicParams_VP9)
set(vp9_d3d11va_hwaccel_select vp9_decoder)
set(vp9_d3d11va2_hwaccel_deps d3d11va DXVA_PicParams_VP9)
set(vp9_d3d11va2_hwaccel_select vp9_decoder)
set(vp9_dxva2_hwaccel_deps dxva2 DXVA_PicParams_VP9)
set(vp9_dxva2_hwaccel_select vp9_decoder)
set(vp9_nvdec_hwaccel_deps nvdec)
set(vp9_nvdec_hwaccel_select vp9_decoder)
set(vp9_vaapi_hwaccel_deps vaapi VADecPictureParameterBufferVP9_bit_depth)
set(vp9_vaapi_hwaccel_select vp9_decoder)
set(vp9_vdpau_hwaccel_deps vdpau VdpPictureInfoVP9)
set(vp9_vdpau_hwaccel_select vp9_decoder)
set(wmv3_d3d11va_hwaccel_select vc1_d3d11va_hwaccel)
set(wmv3_d3d11va2_hwaccel_select vc1_d3d11va2_hwaccel)
set(wmv3_dxva2_hwaccel_select vc1_dxva2_hwaccel)
set(wmv3_nvdec_hwaccel_select vc1_nvdec_hwaccel)
set(wmv3_vaapi_hwaccel_select vc1_vaapi_hwaccel)
set(wmv3_vdpau_hwaccel_select vc1_vdpau_hwaccel)
# hardware-accelerated codecs
set(mediafoundation_deps mftransform_h MFCreateAlignedMemoryBuffer)
set(mediafoundation_extralibs -lmfplat -lmfuuid -lole32 -lstrmiids)
set(omx_deps libdl pthreads)
set(omx_rpi_select omx)
set(qsv_deps libmfx)
set(qsvdec_select qsv)
set(qsvenc_select qsv)
set(qsvvpp_select qsv)
set(vaapi_encode_deps vaapi)
set(v4l2_m2m_deps linux_videodev2_h sem_timedwait)
###
set(hwupload_cuda_filter_deps ffnvcodec)
set(scale_npp_filter_deps ffnvcodec libnpp)
set(scale_cuda_filter_deps ffnvcodec)
set(scale_cuda_filter_deps_any cuda_nvcc cuda_llvm)
set(thumbnail_cuda_filter_deps ffnvcodec)
set(thumbnail_cuda_filter_deps_any cuda_nvcc cuda_llvm)
set(transpose_npp_filter_deps ffnvcodec libnpp)
set(overlay_cuda_filter_deps ffnvcodec)
set(overlay_cuda_filter_deps_any cuda_nvcc cuda_llvm)
###
set(amf_deps_any libdl LoadLibrary)
set(nvenc_deps ffnvcodec)
set(nvenc_deps_any libdl LoadLibrary)
set(nvenc_encoder_deps nvenc)
###
set(aac_mf_encoder_deps mediafoundation)
set(ac3_mf_encoder_deps mediafoundation)
set(h263_v4l2m2m_decoder_deps v4l2_m2m h263_v4l2_m2m)
set(h263_v4l2m2m_encoder_deps v4l2_m2m h263_v4l2_m2m)
set(h264_amf_encoder_deps amf)
set(h264_crystalhd_decoder_select crystalhd h264_mp4toannexb_bsf h264_parser)
set(h264_cuvid_decoder_deps cuvid)
set(h264_cuvid_decoder_select h264_mp4toannexb_bsf)
set(h264_mediacodec_decoder_deps mediacodec)
set(h264_mediacodec_decoder_select h264_mp4toannexb_bsf h264_parser)
set(h264_mf_encoder_deps mediafoundation)
set(h264_mmal_decoder_deps mmal)
set(h264_nvenc_encoder_deps nvenc)
set(h264_omx_encoder_deps omx)
set(h264_qsv_decoder_select h264_mp4toannexb_bsf qsvdec)
set(h264_qsv_encoder_select qsvenc)
set(h264_rkmpp_decoder_deps rkmpp)
set(h264_rkmpp_decoder_select h264_mp4toannexb_bsf)
set(h264_vaapi_encoder_select cbs_h264 vaapi_encode)
set(h264_v4l2m2m_decoder_deps v4l2_m2m h264_v4l2_m2m)
set(h264_v4l2m2m_decoder_select h264_mp4toannexb_bsf)
set(h264_v4l2m2m_encoder_deps v4l2_m2m h264_v4l2_m2m)
set(hevc_amf_encoder_deps amf)
set(hevc_cuvid_decoder_deps cuvid)
set(hevc_cuvid_decoder_select hevc_mp4toannexb_bsf)
set(hevc_mediacodec_decoder_deps mediacodec)
set(hevc_mediacodec_decoder_select hevc_mp4toannexb_bsf hevc_parser)
set(hevc_mf_encoder_deps mediafoundation)
set(hevc_nvenc_encoder_deps nvenc)
set(hevc_qsv_decoder_select hevc_mp4toannexb_bsf qsvdec)
set(hevc_qsv_encoder_select hevcparse qsvenc)
set(hevc_rkmpp_decoder_deps rkmpp)
set(hevc_rkmpp_decoder_select hevc_mp4toannexb_bsf)
set(hevc_vaapi_encoder_deps VAEncPictureParameterBufferHEVC)
set(hevc_vaapi_encoder_select cbs_h265 vaapi_encode)
set(hevc_v4l2m2m_decoder_deps v4l2_m2m hevc_v4l2_m2m)
set(hevc_v4l2m2m_decoder_select hevc_mp4toannexb_bsf)
set(hevc_v4l2m2m_encoder_deps v4l2_m2m hevc_v4l2_m2m)
set(mjpeg_cuvid_decoder_deps cuvid)
set(mjpeg_qsv_decoder_select qsvdec)
set(mjpeg_qsv_encoder_deps libmfx)
set(mjpeg_qsv_encoder_select qsvenc)
set(mjpeg_vaapi_encoder_deps VAEncPictureParameterBufferJPEG)
set(mjpeg_vaapi_encoder_select cbs_jpeg jpegtables vaapi_encode)
set(mp3_mf_encoder_deps mediafoundation)
set(mpeg1_cuvid_decoder_deps cuvid)
set(mpeg1_v4l2m2m_decoder_deps v4l2_m2m mpeg1_v4l2_m2m)
set(mpeg2_crystalhd_decoder_select crystalhd)
set(mpeg2_cuvid_decoder_deps cuvid)
set(mpeg2_mmal_decoder_deps mmal)
set(mpeg2_mediacodec_decoder_deps mediacodec)
set(mpeg2_qsv_decoder_select qsvdec)
set(mpeg2_qsv_encoder_select qsvenc)
set(mpeg2_vaapi_encoder_select cbs_mpeg2 vaapi_encode)
set(mpeg2_v4l2m2m_decoder_deps v4l2_m2m mpeg2_v4l2_m2m)
set(mpeg4_crystalhd_decoder_select crystalhd)
set(mpeg4_cuvid_decoder_deps cuvid)
set(mpeg4_mediacodec_decoder_deps mediacodec)
set(mpeg4_mmal_decoder_deps mmal)
set(mpeg4_omx_encoder_deps omx)
set(mpeg4_v4l2m2m_decoder_deps v4l2_m2m mpeg4_v4l2_m2m)
set(mpeg4_v4l2m2m_encoder_deps v4l2_m2m mpeg4_v4l2_m2m)
set(msmpeg4_crystalhd_decoder_select crystalhd)
set(nvenc_h264_encoder_select h264_nvenc_encoder)
set(nvenc_hevc_encoder_select hevc_nvenc_encoder)
set(vc1_crystalhd_decoder_select crystalhd)
set(vc1_cuvid_decoder_deps cuvid)
set(vc1_mmal_decoder_deps mmal)
set(vc1_qsv_decoder_select qsvdec)
set(vc1_v4l2m2m_decoder_deps v4l2_m2m vc1_v4l2_m2m)
set(vp8_cuvid_decoder_deps cuvid)
set(vp8_mediacodec_decoder_deps mediacodec)
set(vp8_qsv_decoder_select qsvdec)
set(vp8_rkmpp_decoder_deps rkmpp)
set(vp8_vaapi_encoder_deps VAEncPictureParameterBufferVP8)
set(vp8_vaapi_encoder_select vaapi_encode)
set(vp8_v4l2m2m_decoder_deps v4l2_m2m vp8_v4l2_m2m)
set(vp8_v4l2m2m_encoder_deps v4l2_m2m vp8_v4l2_m2m)
set(vp9_cuvid_decoder_deps cuvid)
set(vp9_mediacodec_decoder_deps mediacodec)
set(vp9_qsv_decoder_select qsvdec)
set(vp9_rkmpp_decoder_deps rkmpp)
set(vp9_vaapi_encoder_deps VAEncPictureParameterBufferVP9)
set(vp9_vaapi_encoder_select vaapi_encode)
set(vp9_qsv_encoder_deps libmfx MFX_CODEC_VP9)
set(vp9_qsv_encoder_select qsvenc)
set(vp9_v4l2m2m_decoder_deps v4l2_m2m vp9_v4l2_m2m)
set(wmv3_crystalhd_decoder_select crystalhd)
# parsers
set(aac_parser_select adts_header)
set(av1_parser_select cbs_av1)
set(h264_parser_select golomb h264dsp h264parse)
set(hevc_parser_select hevcparse)
set(mpegaudio_parser_select mpegaudioheader)
set(mpegvideo_parser_select mpegvideo)
set(mpeg4video_parser_select h263dsp mpegvideo qpeldsp)
set(vc1_parser_select vc1dsp)
# bitstream_filters
set(aac_adtstoasc_bsf_select adts_header)
set(av1_frame_merge_bsf_select cbs_av1)
set(av1_frame_split_bsf_select cbs_av1)
set(av1_metadata_bsf_select cbs_av1)
set(eac3_core_bsf_select ac3_parser)
set(filter_units_bsf_select cbs)
set(h264_metadata_bsf_deps const_nan)
set(h264_metadata_bsf_select cbs_h264)
set(h264_redundant_pps_bsf_select cbs_h264)
set(hevc_metadata_bsf_select cbs_h265)
set(mjpeg2jpeg_bsf_select jpegtables)
set(mpeg2_metadata_bsf_select cbs_mpeg2)
set(trace_headers_bsf_select cbs)
set(vp9_metadata_bsf_select cbs_vp9)
# external libraries
set(aac_at_decoder_deps audiotoolbox)
set(aac_at_decoder_select aac_adtstoasc_bsf)
set(ac3_at_decoder_deps audiotoolbox)
set(ac3_at_decoder_select ac3_parser)
set(adpcm_ima_qt_at_decoder_deps audiotoolbox)
set(alac_at_decoder_deps audiotoolbox)
set(amr_nb_at_decoder_deps audiotoolbox)
set(avisynth_deps_any libdl LoadLibrary)
set(avisynth_demuxer_deps avisynth)
set(avisynth_demuxer_select riffdec)
set(eac3_at_decoder_deps audiotoolbox)
set(eac3_at_decoder_select ac3_parser)
set(gsm_ms_at_decoder_deps audiotoolbox)
set(ilbc_at_decoder_deps audiotoolbox)
set(mp1_at_decoder_deps audiotoolbox)
set(mp2_at_decoder_deps audiotoolbox)
set(mp3_at_decoder_deps audiotoolbox)
set(mp1_at_decoder_select mpegaudioheader)
set(mp2_at_decoder_select mpegaudioheader)
set(mp3_at_decoder_select mpegaudioheader)
set(pcm_alaw_at_decoder_deps audiotoolbox)
set(pcm_mulaw_at_decoder_deps audiotoolbox)
set(qdmc_decoder_select fft)
set(qdmc_at_decoder_deps audiotoolbox)
set(qdm2_at_decoder_deps audiotoolbox)
set(aac_at_encoder_deps audiotoolbox)
set(aac_at_encoder_select audio_frame_queue)
set(alac_at_encoder_deps audiotoolbox)
set(alac_at_encoder_select audio_frame_queue)
set(ilbc_at_encoder_deps audiotoolbox)
set(ilbc_at_encoder_select audio_frame_queue)
set(pcm_alaw_at_encoder_deps audiotoolbox)
set(pcm_alaw_at_encoder_select audio_frame_queue)
set(pcm_mulaw_at_encoder_deps audiotoolbox)
set(pcm_mulaw_at_encoder_select audio_frame_queue)
set(chromaprint_muxer_deps chromaprint)
set(h264_videotoolbox_encoder_deps pthreads)
set(h264_videotoolbox_encoder_select videotoolbox_encoder)
set(hevc_videotoolbox_encoder_deps pthreads)
set(hevc_videotoolbox_encoder_select videotoolbox_encoder)
set(libaom_av1_decoder_deps libaom)
set(libaom_av1_encoder_deps libaom)
set(libaom_av1_encoder_select extract_extradata_bsf)
set(libaribb24_decoder_deps libaribb24)
set(libcelt_decoder_deps libcelt)
set(libcodec2_decoder_deps libcodec2)
set(libcodec2_encoder_deps libcodec2)
set(libdav1d_decoder_deps libdav1d)
set(libdavs2_decoder_deps libdavs2)
set(libfdk_aac_decoder_deps libfdk_aac)
set(libfdk_aac_encoder_deps libfdk_aac)
set(libfdk_aac_encoder_select audio_frame_queue)
set(libgme_demuxer_deps libgme)
set(libgsm_decoder_deps libgsm)
set(libgsm_encoder_deps libgsm)
set(libgsm_ms_decoder_deps libgsm)
set(libgsm_ms_encoder_deps libgsm)
set(libilbc_decoder_deps libilbc)
set(libilbc_encoder_deps libilbc)
set(libkvazaar_encoder_deps libkvazaar)
set(libmodplug_demuxer_deps libmodplug)
set(libmp3lame_encoder_deps libmp3lame)
set(libmp3lame_encoder_select audio_frame_queue mpegaudioheader)
set(libopencore_amrnb_decoder_deps libopencore_amrnb)
set(libopencore_amrnb_encoder_deps libopencore_amrnb)
set(libopencore_amrnb_encoder_select audio_frame_queue)
set(libopencore_amrwb_decoder_deps libopencore_amrwb)
set(libopenh264_decoder_deps libopenh264)
set(libopenh264_decoder_select h264_mp4toannexb_bsf)
set(libopenh264_encoder_deps libopenh264)
set(libopenjpeg_decoder_deps libopenjpeg)
set(libopenjpeg_encoder_deps libopenjpeg)
set(libopenmpt_demuxer_deps libopenmpt)
set(libopus_decoder_deps libopus)
set(libopus_encoder_deps libopus)
set(libopus_encoder_select audio_frame_queue)
set(librav1e_encoder_deps librav1e)
set(librav1e_encoder_select extract_extradata_bsf)
set(librsvg_decoder_deps librsvg)
set(libshine_encoder_deps libshine)
set(libshine_encoder_select audio_frame_queue)
set(libspeex_decoder_deps libspeex)
set(libspeex_encoder_deps libspeex)
set(libspeex_encoder_select audio_frame_queue)
set(libtheora_encoder_deps libtheora)
set(libtwolame_encoder_deps libtwolame)
set(libvo_amrwbenc_encoder_deps libvo_amrwbenc)
set(libvorbis_decoder_deps libvorbis)
set(libvorbis_encoder_deps libvorbis libvorbisenc)
set(libvorbis_encoder_select audio_frame_queue)
set(libvpx_vp8_decoder_deps libvpx)
set(libvpx_vp8_encoder_deps libvpx)
set(libvpx_vp9_decoder_deps libvpx)
set(libvpx_vp9_encoder_deps libvpx)
set(libwavpack_encoder_deps libwavpack)
set(libwavpack_encoder_select audio_frame_queue)
set(libwebp_encoder_deps libwebp)
set(libwebp_anim_encoder_deps libwebp)
set(libx262_encoder_deps libx262)
set(libx264_encoder_deps libx264)
set(libx264rgb_encoder_deps libx264 x264_csp_bgr)
set(libx264rgb_encoder_select libx264_encoder)
set(libx265_encoder_deps libx265)
set(libxavs_encoder_deps libxavs)
set(libxavs2_encoder_deps libxavs2)
set(libxvid_encoder_deps libxvid)
set(libzvbi_teletext_decoder_deps libzvbi)
set(vapoursynth_demuxer_deps vapoursynth)
set(videotoolbox_suggest coreservices)
set(videotoolbox_deps corefoundation coremedia corevideo)
set(videotoolbox_encoder_deps videotoolbox VTCompressionSessionPrepareToEncodeFrames)
# demuxers / muxers
set(ac3_demuxer_select ac3_parser)
set(act_demuxer_select riffdec)
set(aiff_muxer_select iso_media)
set(asf_demuxer_select riffdec)
set(asf_o_demuxer_select riffdec)
set(asf_muxer_select riffenc)
set(asf_stream_muxer_select asf_muxer)
set(av1_demuxer_select av1_frame_merge_bsf av1_parser)
set(avi_demuxer_select iso_media riffdec exif)
set(avi_muxer_select riffenc)
set(caf_demuxer_select iso_media riffdec)
set(caf_muxer_select iso_media)
set(dash_muxer_select mp4_muxer)
set(dash_demuxer_deps libxml2)
set(dirac_demuxer_select dirac_parser)
set(dts_demuxer_select dca_parser)
set(dtshd_demuxer_select dca_parser)
set(dv_demuxer_select dvprofile)
set(dv_muxer_select dvprofile)
set(dxa_demuxer_select riffdec)
set(eac3_demuxer_select ac3_parser)
set(f4v_muxer_select mov_muxer)
set(fifo_muxer_deps threads)
set(flac_demuxer_select flac_parser)
set(flv_muxer_select aac_adtstoasc_bsf)
set(gxf_muxer_select pcm_rechunk_bsf)
set(hds_muxer_select flv_muxer)
set(hls_muxer_select mpegts_muxer)
set(hls_muxer_suggest gcrypt openssl)
set(image2_alias_pix_demuxer_select image2_demuxer)
set(image2_brender_pix_demuxer_select image2_demuxer)
set(ipod_muxer_select mov_muxer)
set(ismv_muxer_select mov_muxer)
set(ivf_muxer_select av1_metadata_bsf vp9_superframe_bsf)
set(latm_muxer_select aac_adtstoasc_bsf)
set(matroska_audio_muxer_select matroska_muxer)
set(matroska_demuxer_select iso_media riffdec)
set(matroska_demuxer_suggest bzlib lzo zlib)
set(matroska_muxer_select iso_media riffenc vp9_superframe_bsf aac_adtstoasc_bsf)
set(mlp_demuxer_select mlp_parser)
set(mmf_muxer_select riffenc)
set(mov_demuxer_select iso_media riffdec)
set(mov_demuxer_suggest zlib)
set(mov_muxer_select iso_media riffenc rtpenc_chain vp9_superframe_bsf aac_adtstoasc_bsf)
set(mp3_demuxer_select mpegaudio_parser)
set(mp3_muxer_select mpegaudioheader)
set(mp4_muxer_select mov_muxer)
set(mpegts_demuxer_select iso_media)
set(mpegts_muxer_select adts_muxer latm_muxer h264_mp4toannexb_bsf hevc_mp4toannexb_bsf)
set(mpegtsraw_demuxer_select mpegts_demuxer)
set(mxf_muxer_select golomb pcm_rechunk_bsf)
set(mxf_d10_muxer_select mxf_muxer)
set(mxf_opatom_muxer_select mxf_muxer)
set(nut_muxer_select riffenc)
set(nuv_demuxer_select riffdec)
set(oga_muxer_select ogg_muxer)
set(ogg_demuxer_select dirac_parse)
set(ogv_muxer_select ogg_muxer)
set(opus_muxer_select ogg_muxer)
set(psp_muxer_select mov_muxer)
set(rtp_demuxer_select sdp_demuxer)
set(rtp_muxer_select golomb jpegtables)
set(rtpdec_select asf_demuxer jpegtables mov_demuxer mpegts_demuxer rm_demuxer rtp_protocol srtp)
set(rtsp_demuxer_select http_protocol rtpdec)
set(rtsp_muxer_select rtp_muxer http_protocol rtp_protocol rtpenc_chain)
set(sap_demuxer_select sdp_demuxer)
set(sap_muxer_select rtp_muxer rtp_protocol rtpenc_chain)
set(sdp_demuxer_select rtpdec)
set(smoothstreaming_muxer_select ismv_muxer)
set(spdif_demuxer_select adts_header)
set(spdif_muxer_select adts_header)
set(spx_muxer_select ogg_muxer)
set(swf_demuxer_suggest zlib)
set(tak_demuxer_select tak_parser)
set(truehd_demuxer_select mlp_parser)
set(tg2_muxer_select mov_muxer)
set(tgp_muxer_select mov_muxer)
set(vobsub_demuxer_select mpegps_demuxer)
set(w64_demuxer_select wav_demuxer)
set(w64_muxer_select wav_muxer)
set(wav_demuxer_select riffdec)
set(wav_muxer_select riffenc)
set(webm_chunk_muxer_select webm_muxer)
set(webm_muxer_select iso_media riffenc)
set(webm_dash_manifest_demuxer_select matroska_demuxer)
set(wtv_demuxer_select mpegts_demuxer riffdec)
set(wtv_muxer_select mpegts_muxer riffenc)
set(xmv_demuxer_select riffdec)
set(xwma_demuxer_select riffdec)
# indevs / outdevs
set(android_camera_indev_deps android camera2ndk mediandk pthreads)
set(android_camera_indev_extralibs -landroid -lcamera2ndk -lmediandk)
set(alsa_indev_deps alsa)
set(alsa_outdev_deps alsa)
set(avfoundation_indev_deps avfoundation corevideo coremedia pthreads)
set(avfoundation_indev_suggest coregraphics applicationservices)
set(avfoundation_indev_extralibs -framework Foundation)
set(bktr_indev_deps_any dev_bktr_ioctl_bt848_h machine_ioctl_bt848_h dev_video_bktr_ioctl_bt848_h dev_ic_bt8xx_h)
set(caca_outdev_deps libcaca)
set(decklink_deps_any libdl LoadLibrary)
set(decklink_indev_deps decklink threads)
set(decklink_indev_extralibs -lstdc++)
set(decklink_outdev_deps decklink threads)
set(decklink_outdev_suggest libklvanc)
set(decklink_outdev_extralibs -lstdc++)
set(dshow_indev_deps IBaseFilter)
set(dshow_indev_extralibs -lpsapi -lole32 -lstrmiids -luuid -loleaut32 -lshlwapi)
set(fbdev_indev_deps linux_fb_h)
set(fbdev_outdev_deps linux_fb_h)
set(gdigrab_indev_deps CreateDIBSection)
set(gdigrab_indev_extralibs -lgdi32)
set(gdigrab_indev_select bmp_decoder)
set(iec61883_indev_deps libiec61883)
set(jack_indev_deps libjack)
set(jack_indev_deps_any sem_timedwait dispatch_dispatch_h)
set(kmsgrab_indev_deps libdrm)
set(lavfi_indev_deps avfilter)
set(libcdio_indev_deps libcdio)
set(libdc1394_indev_deps libdc1394)
set(openal_indev_deps openal)
set(opengl_outdev_deps opengl)
set(opengl_outdev_suggest sdl2)
set(oss_indev_deps_any sys_soundcard_h)
set(oss_outdev_deps_any sys_soundcard_h)
set(pulse_indev_deps libpulse)
set(pulse_outdev_deps libpulse)
set(sdl2_outdev_deps sdl2)
set(sndio_indev_deps sndio)
set(sndio_outdev_deps sndio)
set(v4l2_indev_deps_any linux_videodev2_h sys_videoio_h)
set(v4l2_indev_suggest libv4l2)
set(v4l2_outdev_deps_any linux_videodev2_h sys_videoio_h)
set(v4l2_outdev_suggest libv4l2)
set(vfwcap_indev_deps vfw32 vfwcap_defines)
set(xcbgrab_indev_deps libxcb)
set(xcbgrab_indev_suggest libxcb_shm libxcb_shape libxcb_xfixes)
set(xv_outdev_deps xlib)
# protocols
set(async_protocol_deps threads)
set(bluray_protocol_deps libbluray)
set(ffrtmpcrypt_protocol_conflict librtmp_protocol)
set(ffrtmpcrypt_protocol_deps_any gcrypt gmp openssl mbedtls)
set(ffrtmpcrypt_protocol_select tcp_protocol)
set(ffrtmphttp_protocol_conflict librtmp_protocol)
set(ffrtmphttp_protocol_select http_protocol)
set(ftp_protocol_select tcp_protocol)
set(gopher_protocol_select network)
set(http_protocol_select tcp_protocol)
set(http_protocol_suggest zlib)
set(httpproxy_protocol_select tcp_protocol)
set(httpproxy_protocol_suggest zlib)
set(https_protocol_select tls_protocol)
set(https_protocol_suggest zlib)
set(icecast_protocol_select http_protocol)
set(mmsh_protocol_select http_protocol)
set(mmst_protocol_select network)
set(rtmp_protocol_conflict librtmp_protocol)
set(rtmp_protocol_select tcp_protocol)
set(rtmp_protocol_suggest zlib)
set(rtmpe_protocol_select ffrtmpcrypt_protocol)
set(rtmpe_protocol_suggest zlib)
set(rtmps_protocol_conflict librtmp_protocol)
set(rtmps_protocol_select tls_protocol)
set(rtmps_protocol_suggest zlib)
set(rtmpt_protocol_select ffrtmphttp_protocol)
set(rtmpt_protocol_suggest zlib)
set(rtmpte_protocol_select ffrtmpcrypt_protocol ffrtmphttp_protocol)
set(rtmpte_protocol_suggest zlib)
set(rtmpts_protocol_select ffrtmphttp_protocol https_protocol)
set(rtmpts_protocol_suggest zlib)
set(rtp_protocol_select udp_protocol)
set(schannel_conflict openssl gnutls libtls mbedtls)
set(sctp_protocol_deps struct_sctp_event_subscribe struct_msghdr_msg_flags)
set(sctp_protocol_select network)
set(securetransport_conflict openssl gnutls libtls mbedtls)
set(srtp_protocol_select rtp_protocol srtp)
set(tcp_protocol_select network)
set(tls_protocol_deps_any gnutls openssl schannel securetransport libtls mbedtls)
set(tls_protocol_select tcp_protocol)
set(udp_protocol_select network)
set(udplite_protocol_select network)
set(unix_protocol_deps sys_un_h)
set(unix_protocol_select network)
# external library protocols
set(libamqp_protocol_deps librabbitmq)
set(libamqp_protocol_select network)
set(librtmp_protocol_deps librtmp)
set(librtmpe_protocol_deps librtmp)
set(librtmps_protocol_deps librtmp)
set(librtmpt_protocol_deps librtmp)
set(librtmpte_protocol_deps librtmp)
set(libsmbclient_protocol_deps libsmbclient gplv3)
set(libsrt_protocol_deps libsrt)
set(libsrt_protocol_select network)
set(libssh_protocol_deps libssh)
set(libtls_conflict openssl gnutls mbedtls)
set(libzmq_protocol_deps libzmq)
set(libzmq_protocol_select network)
# filters
set(afftdn_filter_deps avcodec)
set(afftdn_filter_select fft)
set(afftfilt_filter_deps avcodec)
set(afftfilt_filter_select fft)
set(afir_filter_deps avcodec)
set(afir_filter_select rdft)
set(amovie_filter_deps avcodec avformat)
set(aresample_filter_deps swresample)
set(asr_filter_deps pocketsphinx)
set(ass_filter_deps libass)
set(atempo_filter_deps avcodec)
set(atempo_filter_select rdft)
set(avgblur_opencl_filter_deps opencl)
set(avgblur_vulkan_filter_deps vulkan libglslang)
set(azmq_filter_deps libzmq)
set(blackframe_filter_deps gpl)
set(bm3d_filter_deps avcodec)
set(bm3d_filter_select dct)
set(boxblur_filter_deps gpl)
set(boxblur_opencl_filter_deps opencl gpl)
set(bs2b_filter_deps libbs2b)
set(chromaber_vulkan_filter_deps vulkan libglslang)
set(colorkey_opencl_filter_deps opencl)
set(colormatrix_filter_deps gpl)
set(convolution_opencl_filter_deps opencl)
set(convolve_filter_deps avcodec)
set(convolve_filter_select fft)
set(coreimage_filter_deps coreimage appkit)
set(coreimage_filter_extralibs -framework OpenGL)
set(coreimagesrc_filter_deps coreimage appkit)
set(coreimagesrc_filter_extralibs -framework OpenGL)
set(cover_rect_filter_deps avcodec avformat gpl)
set(cropdetect_filter_deps gpl)
set(deconvolve_filter_deps avcodec)
set(deconvolve_filter_select fft)
set(deinterlace_qsv_filter_deps libmfx)
set(deinterlace_vaapi_filter_deps vaapi)
set(delogo_filter_deps gpl)
set(denoise_vaapi_filter_deps vaapi)
set(derain_filter_select dnn)
set(deshake_filter_select pixelutils)
set(deshake_opencl_filter_deps opencl)
set(dilation_opencl_filter_deps opencl)
set(dnn_processing_filter_deps swscale)
set(dnn_processing_filter_select dnn)
set(drawtext_filter_deps libfreetype)
set(drawtext_filter_suggest libfontconfig libfribidi)
set(elbg_filter_deps avcodec)
set(eq_filter_deps gpl)
set(erosion_opencl_filter_deps opencl)
set(fftfilt_filter_deps avcodec)
set(fftfilt_filter_select rdft)
set(fftdnoiz_filter_deps avcodec)
set(fftdnoiz_filter_select fft)
set(find_rect_filter_deps avcodec avformat gpl)
set(firequalizer_filter_deps avcodec)
set(firequalizer_filter_select rdft)
set(flite_filter_deps libflite)
set(framerate_filter_select scene_sad)
set(freezedetect_filter_select scene_sad)
set(frei0r_filter_deps frei0r libdl)
set(frei0r_src_filter_deps frei0r libdl)
set(fspp_filter_deps gpl)
set(headphone_filter_select fft)
set(histeq_filter_deps gpl)
set(hqdn3d_filter_deps gpl)
set(interlace_filter_deps gpl)
set(kerndeint_filter_deps gpl)
set(ladspa_filter_deps ladspa libdl)
set(lensfun_filter_deps liblensfun version3)
set(lv2_filter_deps lv2)
set(mcdeint_filter_deps avcodec gpl)
set(movie_filter_deps avcodec avformat)
set(mpdecimate_filter_deps gpl)
set(mpdecimate_filter_select pixelutils)
set(minterpolate_filter_select scene_sad)
set(mptestsrc_filter_deps gpl)
set(negate_filter_deps lut_filter)
set(nlmeans_opencl_filter_deps opencl)
set(nnedi_filter_deps gpl)
set(ocr_filter_deps libtesseract)
set(ocv_filter_deps libopencv)
set(openclsrc_filter_deps opencl)
set(overlay_opencl_filter_deps opencl)
set(overlay_qsv_filter_deps libmfx)
set(overlay_qsv_filter_select qsvvpp)
set(overlay_vulkan_filter_deps vulkan libglslang)
set(owdenoise_filter_deps gpl)
set(pad_opencl_filter_deps opencl)
set(pan_filter_deps swresample)
set(perspective_filter_deps gpl)
set(phase_filter_deps gpl)
set(pp7_filter_deps gpl)
set(pp_filter_deps gpl postproc)
set(prewitt_opencl_filter_deps opencl)
set(procamp_vaapi_filter_deps vaapi)
set(program_opencl_filter_deps opencl)
set(pullup_filter_deps gpl)
set(removelogo_filter_deps avcodec avformat swscale)
set(repeatfields_filter_deps gpl)
set(resample_filter_deps avresample)
set(roberts_opencl_filter_deps opencl)
set(rubberband_filter_deps librubberband)
set(sab_filter_deps gpl swscale)
set(scale2ref_filter_deps swscale)
set(scale_filter_deps swscale)
set(scale_qsv_filter_deps libmfx)
set(scdet_filter_select scene_sad)
set(select_filter_select scene_sad)
set(sharpness_vaapi_filter_deps vaapi)
set(showcqt_filter_deps avcodec avformat swscale)
set(showcqt_filter_suggest libfontconfig libfreetype)
set(showcqt_filter_select fft)
set(showfreqs_filter_deps avcodec)
set(showfreqs_filter_select fft)
set(showspatial_filter_select fft)
set(showspectrum_filter_deps avcodec)
set(showspectrum_filter_select fft)
set(showspectrumpic_filter_deps avcodec)
set(showspectrumpic_filter_select fft)
set(signature_filter_deps gpl avcodec avformat)
set(sinc_filter_select rdft)
set(smartblur_filter_deps gpl swscale)
set(sobel_opencl_filter_deps opencl)
set(sofalizer_filter_deps libmysofa avcodec)
set(sofalizer_filter_select fft)
set(spectrumsynth_filter_deps avcodec)
set(spectrumsynth_filter_select fft)
set(spp_filter_deps gpl avcodec)
set(spp_filter_select fft idctdsp fdctdsp me_cmp pixblockdsp)
set(sr_filter_deps avformat swscale)
set(sr_filter_select dnn)
set(stereo3d_filter_deps gpl)
set(subtitles_filter_deps avformat avcodec libass)
set(super2xsai_filter_deps gpl)
set(pixfmts_super2xsai_test_deps super2xsai_filter)
set(superequalizer_filter_select rdft)
set(surround_filter_select rdft)
set(tinterlace_filter_deps gpl)
set(tinterlace_merge_test_deps tinterlace_filter)
set(tinterlace_pad_test_deps tinterlace_filter)
set(tonemap_filter_deps const_nan)
set(tonemap_vaapi_filter_deps vaapi VAProcFilterParameterBufferHDRToneMapping)
set(tonemap_opencl_filter_deps opencl const_nan)
set(transpose_opencl_filter_deps opencl)
set(transpose_vaapi_filter_deps vaapi VAProcPipelineCaps_rotation_flags)
set(unsharp_opencl_filter_deps opencl)
set(uspp_filter_deps gpl avcodec)
set(vaguedenoiser_filter_deps gpl)
set(vidstabdetect_filter_deps libvidstab)
set(vidstabtransform_filter_deps libvidstab)
set(libvmaf_filter_deps libvmaf pthreads)
set(zmq_filter_deps libzmq)
set(zoompan_filter_deps swscale)
set(zscale_filter_deps libzimg const_nan)
set(scale_vaapi_filter_deps vaapi)
set(scale_vulkan_filter_deps vulkan libglslang)
set(vpp_qsv_filter_deps libmfx)
set(vpp_qsv_filter_select qsvvpp)
set(xfade_opencl_filter_deps opencl)
set(yadif_cuda_filter_deps ffnvcodec)
set(yadif_cuda_filter_deps_any cuda_nvcc cuda_llvm)
# examples
set(avio_list_dir_deps avformat avutil)
set(avio_reading_deps avformat avcodec avutil)
set(decode_audio_example_deps avcodec avutil)
set(decode_video_example_deps avcodec avutil)
set(demuxing_decoding_example_deps avcodec avformat avutil)
set(encode_audio_example_deps avcodec avutil)
set(encode_video_example_deps avcodec avutil)
set(extract_mvs_example_deps avcodec avformat avutil)
set(filter_audio_example_deps avfilter avutil)
set(filtering_audio_example_deps avfilter avcodec avformat avutil)
set(filtering_video_example_deps avfilter avcodec avformat avutil)
set(http_multiclient_example_deps avformat avutil fork)
set(hw_decode_example_deps avcodec avformat avutil)
set(metadata_example_deps avformat avutil)
set(muxing_example_deps avcodec avformat avutil swscale)
set(qsvdec_example_deps avcodec avutil libmfx h264_qsv_decoder)
set(remuxing_example_deps avcodec avformat avutil)
set(resampling_audio_example_deps avutil swresample)
set(scaling_video_example_deps avutil swscale)
set(transcode_aac_example_deps avcodec avformat swresample)
set(transcoding_example_deps avfilter avcodec avformat avutil)
set(vaapi_encode_example_deps avcodec avutil h264_vaapi_encoder)
set(vaapi_transcode_example_deps avcodec avformat avutil h264_vaapi_encoder)
# EXTRALIBS_LIST
set(cpu_init_extralibs pthreads_extralibs)
set(cws2fws_extralibs zlib_extralibs)
# libraries, in any order
set(avcodec_deps avutil)
set(avcodec_suggest libm)
set(avcodec_select null_bsf)
set(avdevice_deps avformat avcodec avutil)
set(avdevice_suggest libm)
set(avfilter_deps avutil)
set(avfilter_suggest libm)
set(avformat_deps avcodec avutil)
set(avformat_suggest libm network zlib)
set(avresample_deps avutil)
set(avresample_suggest libm)
set(avutil_suggest clock_gettime ffnvcodec libm libdrm libmfx opencl user32 vaapi vulkan videotoolbox corefoundation corevideo coremedia bcrypt)
set(postproc_deps avutil gpl)
set(postproc_suggest libm)
set(swresample_deps avutil)
set(swresample_suggest libm libsoxr)
set(swscale_deps avutil)
set(swscale_suggest libm)
###
set(avcodec_extralibs pthreads_extralibs iconv_extralibs dxva2_extralibs)
set(avfilter_extralibs pthreads_extralibs)
set(avutil_extralibs d3d11va_extralibs nanosleep_extralibs pthreads_extralibs vaapi_drm_extralibs vaapi_x11_extralibs vdpau_x11_extralibs)
# programs
set(ffmpeg_deps avcodec avfilter avformat)
set(ffmpeg_select aformat_filter anull_filter atrim_filter format_filter
                  hflip_filter null_filter
                  transpose_filter trim_filter vflip_filter)
set(ffmpeg_suggest ole32 psapi shell32)
set(ffplay_deps avcodec avformat swscale swresample sdl2)
set(ffplay_select rdft crop_filter transpose_filter hflip_filter vflip_filter rotate_filter)
set(ffplay_suggest shell32)
set(ffprobe_deps avcodec avformat)
set(ffprobe_suggest shell32)
# documentation
set(podpages_deps perl)
set(manpages_deps perl pod2man)
set(htmlpages_deps perl)
set(htmlpages_deps_any makeinfo_html texi2html)
set(txtpages_deps perl makeinfo)
set(doc_deps_any manpages htmlpages podpages txtpages)
# default parameters
#logfile="ffbuild/config.log"
# installation paths
set(prefix_default /usr/local)
set(bindir_default ${prefix}/bin)
set(datadir_default ${prefix}/share/ffmpeg)
set(docdir_default ${prefix}/share/doc/ffmpeg)
set(incdir_default ${prefix}/include)
set(libdir_default ${prefix}/lib)
set(mandir_default ${prefix}/share/man)
# toolchain
set(ar_default ar)
set(cc_default gcc)
set(cxx_default g++)
set(host_cc_default gcc)
set(doxygen_default doxygen)
set(install install)
set(ln_s_default ln -s -f)
set(nm_default nm -g)
set(pkg_config_default pkg-config)
set(ranlib_default ranlib)
set(strip_default strip)
set(version_script '--version-script')
set(objformat elf32)
set(x86asmexe_default nasm)
set(windres_default windres)
set(striptype direct)
# OS
#target_os_default=$(tolower $(uname -s))
#host_os=$target_os_default
# machine
#if test "$target_os_default" = aix; then
#    arch_default=$(uname -p)
#    strip_default="strip -X32_64"
#    nm_default="nm -g -X32_64"
#else
#    arch_default=$(uname -m)
#fi
#cpu="generic"
#intrinsics="none"

# configurable options
enable(${PROGRAM_LIST})
enable(${DOCUMENT_LIST})
enable(${EXAMPLE_LIST})
enable(${LIBRARY_LIST})
enable(stripping)
enable(asm)
enable(debug)
enable(doc)
enable(faan faandct faanidct)
enable(large_tests)
enable(optimizations)
enable(runtime_cpudetect)
enable(safe_bitstream_reader)
enable(static)
enable(swscale_alpha)
enable(valgrind_backtrace)
set(sws_max_filter_size_default 256)
# internal components are enabled by default
enable(${EXTRALIBS_LIST})
# Avoid external, non-system, libraries getting enabled by dependency resolution
disable(${EXTERNAL_LIBRARY_LIST} ${HWACCEL_LIBRARY_LIST})
# find_things_extern
function(find_things_extern thing pattern)
  if(DEFINED ARGV3)
    string(TOUPPER ${ARGV3} OUT)
  else()
    string(TOUPPER ${thing} OUT)
  endif()
  set(regexp "^[^#]*extern.*${pattern} *ff_\([^ ]*\)_${thing};")
  file(STRINGS ${CMAKE_SOURCE_DIR}/${ARGV2} lines REGEX "${regexp}")
  list(TRANSFORM lines REPLACE "${regexp}" "\\1_${OUT}")
  set(${OUT}_LIST ${lines} PARENT_SCOPE)
endfunction()
# find_filters_extern
function(find_filters_extern)
  set(regexp "^extern AVFilter ff_[^_]*_\([^ ]*\);")
  file(STRINGS ${CMAKE_SOURCE_DIR}/${ARGV0} lines REGEX "${regexp}")
  list(TRANSFORM lines REPLACE "${regexp}" "\\1_filter")
  set(FILTER_LIST ${lines} PARENT_SCOPE)
endfunction()
find_filters_extern(libavfilter/allfilters.c) # FILTER_LIST
find_things_extern(muxer AVOutputFormat libavdevice/alldevices.c outdev) # OUTDEV_LIST
find_things_extern(demuxer AVInputFormat libavdevice/alldevices.c indev) # INDEV_LIST
find_things_extern(muxer AVOutputFormat libavformat/allformats.c) # MUXER_LIST
find_things_extern(demuxer AVInputFormat libavformat/allformats.c) # DEMUXER_LIST
find_things_extern(encoder AVCodec libavcodec/allcodecs.c) # ENCODER_LIST
find_things_extern(decoder AVCodec libavcodec/allcodecs.c) # DECODER_LIST
set(CODEC_LIST
  ${ENCODER_LIST}
  ${DECODER_LIST}
  )
find_things_extern(parser AVCodecParser libavcodec/parsers.c) # PARSER_LIST
find_things_extern(bsf AVBitStreamFilter libavcodec/bitstream_filters.c) # BSF_LIST
find_things_extern(hwaccel AVHWAccel libavcodec/hwaccels.h) # HWACCEL_LIST
find_things_extern(protocol URLProtocol libavformat/protocols.c) # PROTOCOL_LIST
set(AVCODEC_COMPONENTS_LIST
  ${BSF_LIST}
  ${DECODER_LIST}
  ${ENCODER_LIST}
  ${HWACCEL_LIST}
  ${PARSER_LIST}
  )
set(AVDEVICE_COMPONENTS_LIST
  ${INDEV_LIST}
  ${OUTDEV_LIST}
  )
set(AVFILTER_COMPONENTS_LIST
  ${FILTER_LIST}
  )
set(AVFORMAT_COMPONENTS_LIST
  ${DEMUXER_LIST}
  ${MUXER_LIST}
  ${PROTOCOL_LIST}
  )
set(ALL_COMPONENTS
  ${AVCODEC_COMPONENTS_LIST}
  ${AVDEVICE_COMPONENTS_LIST}
  ${AVFILTER_COMPONENTS_LIST}
  ${AVFORMAT_COMPONENTS_LIST}
  )
enable(${ARCH_EXT_LIST})
########################################
check_func(access)
check_func(fcntl)
check_func(fork)
check_func(gethrtime)
check_func(getopt)
check_func(getrusage)
check_func(gettimeofday)
check_func(isatty)
check_func(mkstemp)
check_func(mmap)
check_func(mprotect)
check_func(sched_getaffinity)
check_func(setrlimit)
check_func(strerror_r)
check_func(sysconf)
check_func(sysctl)
check_func(usleep)
check_func_headers(glob.h glob)
check_headers(direct.h)
check_headers(dirent.h)
check_headers(dxgidebug.h)
check_headers(dxva.h)
#check_headers(dxva2api.h -D_WIN32_WINNT=0x0600)
check_headers(io.h)
check_headers(linux/perf_event.h)
check_headers(libcrystalhd/libcrystalhd_if.h)
check_headers(malloc.h)
check_headers(mftransform.h)
check_headers(net/udplite.h)
check_headers(poll.h)
check_headers(sys/param.h)
check_headers(sys/resource.h)
check_headers(sys/select.h)
check_headers(sys/time.h)
check_headers(sys/un.h)
check_headers(termios.h)
check_headers(unistd.h)
check_headers(valgrind/valgrind.h)
#check_func_headers(VideoToolbox/VTCompressionSession.h VTCompressionSessionPrepareToEncodeFrames -framework VideoToolbox)
check_headers(windows.h)
check_headers(X11/extensions/XvMClib.h)
check_headers(asm/types.h)
set(atan2f_args 2)
set(copysign_args 2)
set(hypot_args 2)
set(ldexpf_args 2)
set(powf_args 2)
foreach(func ${MATH_FUNCS})
  check_mathfunc(${func} ${${func}_args})
endforeach()
########################################
function(head_config)
  file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/config.h
"/* Automatically generated by configure.cmake - do not modify! */
#ifndef FFMPEG_CONFIG_H
#define FFMPEG_CONFIG_H"
  )
endfunction()
function(print_config pfx files)
  separate_arguments(files)
  foreach(c ${ARGN})
    string(TOUPPER ${c} C)
    foreach(f ${files})
      if(f MATCHES ".h$")
        unset(val)
        if(DEFINED ${c})
          if(${${c}} STREQUAL "ON")
            set(val 1)
          elseif(${${c}} STREQUAL "OFF")
            set(val 0)
          endif()
        endif()
        set(${f}_x "${${f}_x}\n#define ${pfx}${C} ${val}")
      else()
        set(${f}_x "${${f}_x}\nsomething ${pfx}${C}")
      endif()
    endforeach()
  endforeach()
  foreach(f ${files})
    file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/${f} ${${f}_x})
  endforeach()
endfunction()
head_config()
print_config(ARCH_ "config.h" ${ARCH_LIST})
print_config(HAVE_ "config.h" ${HAVE_LIST})
print_config(CONFIG_ "config.h" ${CONFIG_LIST} ${CONFIG_EXTRA} ${ALL_COMPONENTS})
file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/config.h "\n#endif /* FFMPEG_CONFIG_H */")
