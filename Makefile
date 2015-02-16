all:
	xcrun  -sdk macosx swiftc main.swift dealing-with-nserror.swift
clean:
	rm main
