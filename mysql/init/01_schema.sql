create table albums
(
    album_id           bigint auto_increment comment '앨범 고유 식별자'
        primary key,
    album_name         varchar(255)                         not null comment '앨범 이름',
    album_release_date date                                 not null comment '앨범 발매일',
    album_image        varchar(255)                         not null comment '앨범 이미지',
    like_count         bigint                               not null comment '좋아요 수',
    is_deleted         tinyint(1) default 0                 not null comment '앨범 삭제 여부, 0: 삭제 안됨 / 1: 삭제',
    created_at         datetime   default CURRENT_TIMESTAMP not null comment '생성 시점',
    modified_at        datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '수정 시점',
    jamendo_album_id   bigint                               null comment 'Jamendo 앨범 고유 식별자',
    constraint uk_albums_album_image
        unique (album_image),
    constraint uk_songs_jamendo_album_id
        unique (jamendo_album_id)
);

create fulltext index ft_album_name
    on albums (album_name);

create table artists
(
    artist_id         bigint auto_increment comment '아티스트 고유 식별자'
        primary key,
    artist_name       varchar(255)                         not null comment '아티스트 이름',
    like_count        bigint                               not null comment '좋아요 수',
    is_deleted        tinyint(1) default 0                 null comment '아티스트 삭제 여부, 0: 삭제 안됨 / 1: 삭제',
    created_at        datetime   default CURRENT_TIMESTAMP not null comment '생성 시점',
    modified_at       datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '수정 시점',
    jamendo_artist_id bigint                               null comment 'Jamendo 아티스트 고유 식별자',
    profile_image     varchar(2048)                        null comment '아티스트 프로필 이미지',
    country           varchar(100)                         null comment '활동 국가',
    artist_type       varchar(20)                          null comment '아티스트 유형',
    debut_date        date                                 null comment '데뷔일',
    bio               varchar(500)                         null comment '소개글',
    constraint uk_songs_jamendo_artist_id
        unique (jamendo_artist_id)
);

create table artist_albums
(
    artist_album_id bigint auto_increment comment '아티스트-앨범 고유 식별자'
        primary key,
    artist_id       bigint not null comment '아티스트 고유 식별자(FK)',
    album_id        bigint not null comment '앨범 고유 식별자(FK)',
    constraint uk_artist_albums_artist_id_album_id
        unique (artist_id, album_id),
    constraint fk_artist_albums_album_id
        foreign key (album_id) references albums (album_id),
    constraint fk_artist_albums_artist_id
        foreign key (artist_id) references artists (artist_id)
);

create index idx_artist_albums_album_id
    on artist_albums (album_id);

create index idx_artist_albums_artist_id
    on artist_albums (artist_id);

create fulltext index ft_artist_name
    on artists (artist_name);

create table genres
(
    genre_id   bigint auto_increment comment '장르 고유 식별자'
        primary key,
    genre_name varchar(20) not null comment '장르 이름',
    constraint uk_genres_genre_name
        unique (genre_name)
);

create table songs
(
    song_id           bigint auto_increment comment '음원 고유 식별자'
        primary key,
    album_id          bigint                               not null comment '앨범 고유 식별자 (FK)',
    name              varchar(255)                         not null comment '음원 이름',
    duration          bigint                               not null comment '음원 길이',
    license_ccurl     varchar(255)                         null comment '저작권 정보',
    position          bigint                               not null comment '수록 순서',
    audio             varchar(255)                         not null comment '음원 url',
    vocalinstrumental varchar(255)                         null comment '음원 보컬 유무',
    lang              varchar(255)                         null comment '음원 언어',
    speed             varchar(255)                         null comment '음원 속도',
    instruments       varchar(255)                         null comment '악기 종류',
    vartags           varchar(255)                         null comment '음원 분위기',
    like_count        bigint                               not null comment '좋아요 수',
    is_deleted        tinyint(1) default 0                 not null comment '회원 삭제 여부, 0: 삭제 안됨 / 1: 삭제',
    created_at        datetime   default CURRENT_TIMESTAMP not null comment '생성 시점',
    modified_at       datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '수정 시점',
    jamendo_song_id   bigint                               null comment 'Jamendo 음원 고유 식별자',
    play_count        bigint     default 0                 not null comment '재생 횟수',
    streaming_status  tinyint(1) default 0                 null comment '스트리밍 가능 여부, 0: 스트리밍 불가능 / 1: 스트리밍 가능',
    release_date      date                                 not null comment '발매일',
    constraint uk_songs_audio
        unique (audio),
    constraint uk_songs_jamendo_song_id
        unique (jamendo_song_id),
    constraint fk_songs_album_id
        foreign key (album_id) references albums (album_id)
);

create table artist_songs
(
    artist_song_id bigint auto_increment comment '아티스트-음원 고유 식별자'
        primary key,
    artist_id      bigint not null comment '아티스트 고유 식별자(FK)',
    song_id        bigint not null comment '음원 고유 식별자(FK)',
    constraint uk_artist_songs_artist_id_song_id
        unique (artist_id, song_id),
    constraint fk_artist_song_artist_id
        foreign key (artist_id) references artists (artist_id),
    constraint fk_artist_song_song_id
        foreign key (song_id) references songs (song_id)
);

create index idx_artist_song_artist_id
    on artist_songs (artist_id);

create index idx_artist_song_song_id
    on artist_songs (song_id);

create table song_genres
(
    song_genre_id bigint auto_increment comment '음원-장르 고유 식별자'
        primary key,
    song_id       bigint not null comment '음원 고유 식별자(FK)',
    genre_id      bigint not null comment '장르 고유 식별자(FK)',
    constraint uk_song_genre_song_id_genre_id
        unique (song_id, genre_id),
    constraint fk_song_genre_genre_id
        foreign key (genre_id) references genres (genre_id),
    constraint fk_song_genre_song_id
        foreign key (song_id) references songs (song_id)
);

create index idx_song_genre_genre_id
    on song_genres (genre_id);

create index idx_song_genre_song_id
    on song_genres (song_id);

create table song_progressing_status
(
    song_progressing_status_id bigint auto_increment
        primary key,
    song_id                    bigint      not null comment '음원 고유 식별자',
    progressing_status         varchar(32) not null,
    constraint uk_streaming_jobs_song_id
        unique (song_id),
    constraint fk_streaming_jobs_song_id
        foreign key (song_id) references songs (song_id)
);

create index idx_streaming_jobs_song_id
    on song_progressing_status (song_id);

create fulltext index ft_song_name
    on songs (name);

create index idx_songs_album_id
    on songs (album_id);

create table users
(
    user_id        bigint auto_increment comment '유저 식별자'
        primary key,
    name           varchar(50)                           not null comment '유저 이름',
    nickname       varchar(10)                           not null comment '회원 닉네임',
    email          varchar(255)                          not null comment '회원 이메일',
    password       varchar(255)                          not null comment '회원 비밀번호(BCrypt 인코딩)',
    role           varchar(10) default 'USER'            not null comment '회원 권한',
    is_deleted     tinyint(1)  default 0                 not null comment '회원 삭제 여부, 0: 삭제 안됨 / 1: 삭제',
    created_at     datetime    default CURRENT_TIMESTAMP not null comment '생성 시점',
    modified_at    datetime    default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '수정 시점',
    token_version  bigint      default 0                 not null comment '토큰 버전',
    email_verified tinyint(1)  default 0                 not null comment '이메일 인증 여부',
    constraint uk_users_email
        unique (email),
    constraint uk_users_nickname
        unique (nickname)
);

create table album_likes
(
    album_like_id bigint auto_increment comment '앨범-좋아요 고유 식별자'
        primary key,
    user_id       bigint not null comment '유저 고유 식별자(FK)',
    album_id      bigint not null comment '앨범 고유 식별자(FK)',
    constraint uk_album_likes_user_id_album_id
        unique (user_id, album_id),
    constraint fk_album_likes_user_id
        foreign key (user_id) references users (user_id),
    constraint fk_albums_likes_album_id
        foreign key (album_id) references albums (album_id)
);

create index idx_album_likes_album_id
    on album_likes (album_id);

create index idx_album_likes_user_id
    on album_likes (user_id);

create table artist_likes
(
    artist_like_id bigint auto_increment comment '아티스트-좋아요 고유 식별자'
        primary key,
    user_id        bigint not null comment '유저 고유 식별자(FK)',
    artist_id      bigint not null comment '아티스트 고유 식별자(FK)',
    constraint uk_artist_albums_user_id_artist_id
        unique (user_id, artist_id),
    constraint fk_artists_likes_artist_id
        foreign key (artist_id) references artists (artist_id),
    constraint fk_artists_likes_user_id
        foreign key (user_id) references users (user_id)
);

create index idx_artist_likes_artist_id
    on artist_likes (artist_id);

create index idx_artist_likes_user_id
    on artist_likes (user_id);

create table playlists
(
    playlist_id    bigint auto_increment comment '플레이리스트 고유 식별자'
        primary key,
    user_id        bigint                             not null comment '유저 고유 식별자',
    playlist_name  varchar(255)                       not null comment '플레이리스트 이름',
    created_at     datetime default CURRENT_TIMESTAMP not null comment '생성 시점',
    modified_at    datetime default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '수정 시점',
    playlist_image varchar(255)                       null comment '플레이리스트 이미지',
    constraint fk_playlist_user_id
        foreign key (user_id) references users (user_id)
);

create table playlist_songs
(
    playlist_song_id bigint auto_increment comment '플레이리스트-음원 고유 식별자'
        primary key,
    song_id          bigint not null comment '음원 고유 식별자(FK)',
    playlist_id      bigint not null comment '플레이리스트 고유 식별자(FK)',
    constraint uk_playlist_song_song_id_playlist_id
        unique (song_id, playlist_id),
    constraint fk_playlist_song_playlist_id
        foreign key (playlist_id) references playlists (playlist_id),
    constraint fk_playlist_song_song_id
        foreign key (song_id) references songs (song_id)
);

create index idx_playlist_song_playlist_id
    on playlist_songs (playlist_id);

create index idx_playlist_song_song_id
    on playlist_songs (song_id);

create index idx_playlist_user_id
    on playlists (user_id);

create table song_likes
(
    song_like_id bigint auto_increment comment '음원-좋아요 고유 식별자'
        primary key,
    user_id      bigint not null comment '유저 고유 식별자(FK)',
    song_id      bigint not null comment '음원 고유 식별자(FK)',
    constraint uk_song_likes_user_id_song_id
        unique (user_id, song_id),
    constraint fk_song_likes_song_id
        foreign key (song_id) references songs (song_id),
    constraint fk_song_likes_user_id
        foreign key (user_id) references users (user_id)
);

create index idx_song_likes_song_id
    on song_likes (song_id);

create index idx_song_likes_user_id
    on song_likes (user_id);

